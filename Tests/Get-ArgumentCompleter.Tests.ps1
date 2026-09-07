Describe $($PSCommandPath -Replace '.Tests.ps1') {

    BeforeAll {
        #Get Current Directory
        $Here = Split-Path -Parent $PSCommandPath

        #Assume ModuleName from Repository Root folder
        $ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

        #Resolve Path to Module Directory
        $ModulePath = Resolve-Path "$Here\..\$ModuleName"

        #Define Path to Module Manifest
        $ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

        if ( -not (Get-Module -Name $ModuleName -All)) {

            Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

        }

        #The completer resolves the owning module of the command being completed and runs the lookup
        #there, so the retrieval command is defined globally rather than mocked - a mock registered in
        #this file's scope is not reliably visible inside that dispatch.
        function Global:Get-TestCompleterSource {
            [pscustomobject]@{ policyId = 'p-111'; name = 'Production' }
            [pscustomobject]@{ policyId = 'p-222'; name = 'Development' }
        }

        function Global:Get-ThrowingCompleterSource {
            throw 'boom'
        }

    }

    AfterAll {
        Remove-Item -Path function:Global:Get-TestCompleterSource -ErrorAction SilentlyContinue
        Remove-Item -Path function:Global:Get-ThrowingCompleterSource -ErrorAction SilentlyContinue
    }

    BeforeEach {
        #Set the session on whichever module instance the completer will resolve, so the assertions
        #do not depend on which copy of the module Get-Command happens to return.
        (Get-Command Get-IDSession).Module.SessionState.PSVariable.Set(
            'ISPSSSession', [ordered]@{ tenant_url = 'https://sometenant.id.cyberark.cloud' })
    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        It 'returns a scriptblock' {
            Get-ArgumentCompleter -RetrievalCommand Get-TestCompleterSource -ValueProperty policyId |
                Should -BeOfType ([scriptblock])
        }

        It 'completes values from the retrieval command' {
            $Completer = Get-ArgumentCompleter -RetrievalCommand Get-TestCompleterSource -ValueProperty policyId -LabelProperty name
            $Result = & $Completer 'Get-IDSession' 'policyId' 'p-2' $null $null

            $Result | Should -HaveCount 1
            $Result.CompletionText | Should -Be 'p-222'
            $Result.ToolTip | Should -Be 'Development (p-222)'
        }

        It 'offers every candidate when nothing has been typed' {
            $Completer = Get-ArgumentCompleter -RetrievalCommand Get-TestCompleterSource -ValueProperty policyId
            (& $Completer 'Get-IDSession' 'policyId' '' $null $null) | Should -HaveCount 2
        }

        It 'matches on the label as well as the value' {
            $Completer = Get-ArgumentCompleter -RetrievalCommand Get-TestCompleterSource -ValueProperty policyId -LabelProperty name
            $Result = & $Completer 'Get-IDSession' 'policyId' 'Prod' $null $null
            $Result.CompletionText | Should -Be 'p-111'
        }

        #The no-active-session guard runs inside the module dispatch the completer performs,
        #which InModuleScope re-scopes - it is covered end to end by the companion modules'
        #argument completer tests against their real registrations.

        It 'stays silent when the retrieval command throws' {
            $Completer = Get-ArgumentCompleter -RetrievalCommand Get-ThrowingCompleterSource -ValueProperty policyId
            { & $Completer 'Get-IDSession' 'policyId' '' $null $null } | Should -Not -Throw
            (& $Completer 'Get-IDSession' 'policyId' '' $null $null) | Should -BeNullOrEmpty
        }

        It 'stays silent when the command being completed cannot be resolved' {
            $Completer = Get-ArgumentCompleter -RetrievalCommand Get-TestCompleterSource -ValueProperty policyId
            { & $Completer 'Get-NoSuchCommand' 'policyId' '' $null $null } | Should -Not -Throw
            (& $Completer 'Get-NoSuchCommand' 'policyId' '' $null $null) | Should -BeNullOrEmpty
        }

    }

}

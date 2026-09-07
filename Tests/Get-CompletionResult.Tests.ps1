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

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        It 'returns a CompletionResult for a prefix match on the value' {
            $items = @(
                [pscustomobject]@{ connectorId = 'c-111'; name = 'EU-Connector' }
                [pscustomobject]@{ connectorId = 'c-222'; name = 'US-Connector' }
            )
            $result = $items | Get-CompletionResult -WordToComplete 'c-2' -ValueProperty 'connectorId', 'id' -LabelProperty 'name'
            $result | Should -HaveCount 1
            $result | Should -BeOfType ([System.Management.Automation.CompletionResult])
            $result.CompletionText | Should -Be 'c-222'
            $result.ToolTip | Should -Be 'US-Connector (c-222)'
        }

        It 'also matches on the label' {
            $items = @([pscustomobject]@{ connectorId = 'c-111'; name = 'EU-Connector' })
            $result = $items | Get-CompletionResult -WordToComplete 'EU' -ValueProperty 'connectorId' -LabelProperty 'name'
            $result.CompletionText | Should -Be 'c-111'
        }

        It 'falls back through the value property list' {
            $items = @([pscustomobject]@{ id = 'fallback-id'; name = 'X' })
            $result = $items | Get-CompletionResult -WordToComplete '' -ValueProperty 'connectorId', 'id' -LabelProperty 'name'
            $result.CompletionText | Should -Be 'fallback-id'
        }

        It 'single quotes a value containing whitespace' {
            $items = @([pscustomobject]@{ name = 'target set one' })
            $result = $items | Get-CompletionResult -WordToComplete '' -ValueProperty 'name'
            $result.CompletionText | Should -Be "'target set one'"
        }

        It 'returns nothing when no candidate property holds a value' {
            $items = @([pscustomobject]@{ other = 'x' })
            $items | Get-CompletionResult -WordToComplete '' -ValueProperty 'connectorId', 'id' | Should -BeNullOrEmpty
        }

        It 'strips a quote the user has already typed' {
            $items = @([pscustomobject]@{ name = 'target set one' })
            $result = $items | Get-CompletionResult -WordToComplete "'target" -ValueProperty 'name'
            $result.CompletionText | Should -Be "'target set one'"
        }

    }

}

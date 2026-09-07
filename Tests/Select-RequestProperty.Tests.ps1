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

        It 'returns only the supplied properties' {
            $Result = Select-RequestProperty -Property @('name', 'description') -BoundParameter @{ name = 'SomeName' }
            @($Result.Keys) | Should -Be @('name')
        }

        It 'returns the properties in the requested order' {
            $Result = Select-RequestProperty -Property @('csp', 'name', 'description') -BoundParameter @{ description = 'd'; name = 'n'; csp = 'AWS' }
            @($Result.Keys) | Should -Be @('csp', 'name', 'description')
        }

        It 'ignores parameters which are not expected properties' {
            $Result = Select-RequestProperty -Property @('name') -BoundParameter @{ name = 'SomeName'; policy_id = 'SomePolicy' }
            $Result.Keys | Should -Not -Contain 'policy_id'
        }

        It 'returns an empty set when no parameters were supplied' {
            (Select-RequestProperty -Property @('name') -BoundParameter $null).Count | Should -Be 0
        }
    }

}

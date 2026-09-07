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

        It 'takes the value of a supplied parameter' {
            $Result = Merge-Parameter -Template ([ordered]@{ name = $null }) -BoundParameter @{ name = 'SomeName' }
            $Result['name'] | Should -Be 'SomeName'
        }

        It 'falls back to the template default' {
            $Result = Merge-Parameter -Template ([ordered]@{ name = 'DefaultName' }) -BoundParameter @{ }
            $Result['name'] | Should -Be 'DefaultName'
        }

        It 'falls back to the supplied object' {
            $Result = Merge-Parameter -Template ([ordered]@{ name = 'DefaultName' }) -BoundParameter @{ } -Fallback ([pscustomobject]@{ name = 'ExistingName' })
            $Result['name'] | Should -Be 'ExistingName'
        }

        It 'preserves the order of the template keys' {
            $Result = Merge-Parameter -Template ([ordered]@{ name = $null; description = $null; endDate = $null }) -BoundParameter @{ description = 'SomeDescription' }
            @($Result.Keys) | Should -Be @('name', 'description', 'endDate')
        }
    }

}

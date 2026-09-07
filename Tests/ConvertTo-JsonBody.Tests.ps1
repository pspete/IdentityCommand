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

        It 'serialises an object to JSON' {
            (ConvertTo-JsonBody -Body @{ name = 'SomeName' } | ConvertFrom-Json).name | Should -Be 'SomeName'
        }

        It 'preserves a single element collection as an array' {
            $Json = ConvertTo-JsonBody -Body @{ sessionIds = @('SomeSession') }
            $Json | Should -Match '"sessionIds":\s*\['
        }

        It 'preserves property order' {
            $Json = ConvertTo-JsonBody -Body ([ordered]@{ csp = 'AWS'; name = 'SomeName' })
            ($Json | ConvertFrom-Json).PSObject.Properties.Name | Should -Be @('csp', 'name')
        }

        It 'emits compact JSON when requested' {
            ConvertTo-JsonBody -Body @{ name = 'SomeName' } -Compress | Should -Be '{"name":"SomeName"}'
        }
    }

}

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

        It 'returns the URI unaltered when there is nothing to append' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }

        It 'appends a query string' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ limit = 10 } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10'
        }

        It 'joins to an existing query string' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10' -Parameter @{ nextToken = 'SomeToken' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?limit=10&nextToken=SomeToken'
        }

        It 'drops null and empty values' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ limit = $null; free_text = '' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }

        It 'escapes values' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -Parameter @{ free_text = 'some text' } |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?free_text=some%20text'
        }

        It 'does not request debug information by default' {
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -SupportsDebug |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies'
        }

        It 'requests debug information when the debug preference is set' {
            $DebugPreference = 'Continue'
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/policies' -SupportsDebug |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/policies?debug=true'
        }

        It 'does not request debug information for an endpoint which does not support it' {
            $DebugPreference = 'Continue'
            Add-QueryString -URI 'https://somedomain.sca.cyberark.cloud/api/access/sessions' |
                Should -Be 'https://somedomain.sca.cyberark.cloud/api/access/sessions'
        }
    }

}

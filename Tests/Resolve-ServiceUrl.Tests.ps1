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

    BeforeEach {

        Mock -CommandName Find-SharedServicesURL -ModuleName IdentityCommand -MockWith {
            [pscustomobject]@{
                sca                  = [pscustomobject]@{ api = 'https://sometenant.sca.cyberark.cloud/api' }
                jit                  = [pscustomobject]@{ api = 'https://sometenant.dpa.cyberark.cloud/api' }
                identity_user_portal = [pscustomobject]@{ api = 'https://sometenant.id.cyberark.cloud/' }
            }
        }

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'Subdomain parameter set' {

            It 'queries platform discovery by subdomain' {
                $null = Resolve-ServiceUrl -Service sca -Subdomain 'sometenant'
                Should -Invoke -CommandName Find-SharedServicesURL -ParameterFilter {
                    $subdomain -eq 'sometenant'
                } -Times 1 -Exactly -Scope It
            }

            It 'returns the service URL with any trailing /api removed' {
                (Resolve-ServiceUrl -Service sca -Subdomain 'sometenant').ServiceUrl |
                    Should -Be 'https://sometenant.sca.cyberark.cloud'
            }

            It 'returns the CyberArk Identity URL with any trailing slash removed' {
                (Resolve-ServiceUrl -Service sca -Subdomain 'sometenant').IdentityUrl |
                    Should -Be 'https://sometenant.id.cyberark.cloud'
            }

        }

        Context 'URL parameter set' {

            It 'queries platform discovery by url' {
                $null = Resolve-ServiceUrl -Service sca -Url 'https://sometenant.sca.cyberark.cloud'
                Should -Invoke -CommandName Find-SharedServicesURL -ParameterFilter {
                    $url -eq 'https://sometenant.sca.cyberark.cloud'
                } -Times 1 -Exactly -Scope It
            }

            It 'resolves both URLs from a supplied url' {
                $result = Resolve-ServiceUrl -Service sca -Url 'https://sometenant.sca.cyberark.cloud'
                $result.ServiceUrl | Should -Be 'https://sometenant.sca.cyberark.cloud'
                $result.IdentityUrl | Should -Be 'https://sometenant.id.cyberark.cloud'
            }

        }

        Context 'Service selection' {

            It 'returns the url of the requested service' -ForEach @(
                @{ Service = 'sca'; Expected = 'https://sometenant.sca.cyberark.cloud' }
                @{ Service = 'jit'; Expected = 'https://sometenant.dpa.cyberark.cloud' }
            ) {
                (Resolve-ServiceUrl -Service $Service -Subdomain 'sometenant').ServiceUrl |
                    Should -Be $Expected
            }

            It 'returns the same Identity URL whichever service is requested' -ForEach @(
                @{ Service = 'sca' }
                @{ Service = 'jit' }
            ) {
                (Resolve-ServiceUrl -Service $Service -Subdomain 'sometenant').IdentityUrl |
                    Should -Be 'https://sometenant.id.cyberark.cloud'
            }

            It 'returns a null service url for a service absent from the discovery response' {
                (Resolve-ServiceUrl -Service pcloud -Subdomain 'sometenant').ServiceUrl |
                    Should -BeNullOrEmpty
            }

        }

        Context 'Error handling' {

            It 'wraps a discovery failure in a descriptive error' {
                Mock -CommandName Find-SharedServicesURL -MockWith { throw 'boom' }
                { Resolve-ServiceUrl -Service sca -Subdomain 'sometenant' } |
                    Should -Throw "*Unable to resolve CyberArk shared services URLs from 'sometenant'*boom*"
            }

            It 'throws when the discovery response has no identity_user_portal URL' {
                Mock -CommandName Find-SharedServicesURL -MockWith {
                    [pscustomobject]@{
                        sca                  = [pscustomobject]@{ api = 'https://sometenant.sca.cyberark.cloud/api' }
                        identity_user_portal = [pscustomobject]@{ api = '' }
                    }
                }
                { Resolve-ServiceUrl -Service sca -Url 'https://sometenant.sca.cyberark.cloud' } |
                    Should -Throw "*identity_user_portal*not found*"
            }

        }

    }

}

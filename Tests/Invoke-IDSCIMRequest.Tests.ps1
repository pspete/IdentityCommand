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

        BeforeEach {

            $ISPSSSession = [ordered]@{
                tenant_url         = 'https://somedomain.id.cyberark.cloud'
                User               = $null
                TenantId           = 'SomeTenant'
                SessionId          = 'SomeSession'
                WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime          = $null
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = $null
                LastCommandResults = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'property' = 'value' }
            }

        }

        Context 'Collection request' {

            BeforeEach {
                $response = Invoke-IDSCIMRequest -Resource 'Users' -Method 'GET'
            }

            It 'sends request to the collection endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/scim/Users' -and $Method -eq 'GET'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Resource request' {

            BeforeEach {
                $response = Invoke-IDSCIMRequest -Resource 'Users' -Method 'DELETE' -ID 'someuserid'
            }

            It 'sends request to the resource endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/scim/Users/someuserid' -and $Method -eq 'DELETE'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Collection request with a SCIM ListResponse envelope' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{
                        schemas      = @('urn:ietf:params:scim:api:messages:2.0:ListResponse')
                        totalResults = 2
                        itemsPerPage = 2
                        startIndex   = 1
                        Resources    = @(
                            [pscustomobject]@{ name = 'User' }
                            [pscustomobject]@{ name = 'Group' }
                        )
                    }
                }

                $response = Invoke-IDSCIMRequest -Resource 'ResourceTypes' -Method 'GET'

            }

            It 'flattens the envelope to just the Resources array' {

                $response | Should -HaveCount 2
                $response[0].name | Should -Be 'User'
                $response[1].name | Should -Be 'Group'

            }

        }

        Context 'Request with body' {

            BeforeEach {
                $response = Invoke-IDSCIMRequest -Resource 'Users' -Method 'POST' -Body @{ 'userName' = 'someuser' }
            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty userName) -eq 'someuser'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}

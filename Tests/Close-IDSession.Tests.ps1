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
            Mock Invoke-IDRestMethod -MockWith {

            }

            Mock Remove-Variable -MockWith {

            }

            $response = Close-IDSession

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/Logout'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

            It 'removes the expected module scope variables' {
                Assert-MockCalled -CommandName Remove-Variable -Times 3 -Exactly -Scope It -ParameterFilter {
                    $Name -eq 'tenant_url'
                    $Scope -eq 'Script'
                }
                Assert-MockCalled -CommandName Remove-Variable -Times 3 -Exactly -Scope It -ParameterFilter {
                    $Name -eq 'WebSession'
                    $Scope -eq 'Script'
                }
                Assert-MockCalled -CommandName Remove-Variable -Times 3 -Exactly -Scope It -ParameterFilter {
                    $Name -eq 'TenantId'
                    $Scope -eq 'Script'
                }
            }

        }

        Context 'Output' {

            It 'provides no output' {

                $response | Should -BeNullOrEmpty

            }

        }

    }

}
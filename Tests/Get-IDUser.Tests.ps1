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
            $Script:tenant_url = 'https://somedomain.id.cyberark.cloud'
        }

        Context 'GetUsers' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'Results' = @(
                            [pscustomobject]@{
                                'Row' = [pscustomobject]@{
                                    'property' = 'value'
                                    'test'     = 'result'
                                }
                            },
                            [pscustomobject]@{
                                'Row' = [pscustomobject]@{
                                    'property' = 'value'
                                    'test'     = 'result'
                                }
                            },
                            [pscustomobject]@{
                                'Row' = [pscustomobject]@{
                                    'property' = 'value'
                                    'test'     = 'result'
                                }
                            }
                        )
                    }
                }
                $response = Get-IDUser
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUsers'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with no body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -eq $null } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs expected number of results' {

                $response.length | Should -Be 3

            }

            It 'outputs expected result' {

                $response | Select-Object -First 1 -ExpandProperty property | Should -Be 'value'

            }

        }

        Context 'GetUser' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ 'property' = 'value' }
                }
                $response = Get-IDUser -id someid
            }


            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUser'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when object with UUID is provided via pipe' {

                [pscustomobject]@{'Uuid' = 5678 } | Get-IDUser

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUser'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty id) -eq 'someid'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs expected number of results' {

                $response.length | Should -Be 1

            }

            It 'outputs expected result' {

                $response | Select-Object -ExpandProperty property | Should -Be 'value'

            }

        }

        Context 'GetUserByName' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ 'property' = 'value' }
                }
                $response = Get-IDUser -username somename
            }


            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUserByName'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when object with username is provided via pipe' {

                [pscustomobject]@{'username' = 'somename' } | Get-IDUser

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUserByName'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty username) -eq 'somename'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs expected number of results' {

                $response.length | Should -Be 1

            }

            It 'outputs expected result' {

                $response | Select-Object -ExpandProperty property | Should -Be 'value'

            }

        }

    }

}
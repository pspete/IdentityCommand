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
                LastError          = $null
                LastErrorTime      = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
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
                $response = Invoke-IDSqlcmd -Script 'Some SQL Query' -Limit 3
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Redrock/query'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected script' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ($Body | ConvertFrom-Json | Select-Object -ExpandProperty Script) -eq 'Some SQL Query'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected args' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ($Body | ConvertFrom-Json | Select-Object -ExpandProperty args).Limit -eq 3

                } -Times 1 -Exactly -Scope It

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

    }

}
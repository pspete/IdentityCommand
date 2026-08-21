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
        }

        Context 'Redrock' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'Results' = @(
                            [pscustomobject]@{
                                'Row' = [pscustomobject]@{
                                    'property' = 'value'
                                    'test'     = 'result'
                                }
                            }
                        )
                    }
                }
                $response = Get-IDRole
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/redrock/query/'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'Post' } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs expected result' {

                $response | Select-Object -First 1 -ExpandProperty property | Should -Be 'value'

            }

        }

        Context 'API' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ 'property' = 'value' }
                }
                $response = Get-IDRole -Name 'SomeRole'
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ([system.uri]::new($URI) | Select-Object -ExpandProperty AbsolutePath) -match '/Roles/GetRole'

                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ([system.uri]::new($URI) | Select-Object -ExpandProperty query) -match 'Name=SomeRole'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when object with UUID is provided via pipe' {

                [pscustomobject]@{'Uuid' = 'SomeRole' } | Get-IDRole

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ([system.uri]::new($URI) | Select-Object -ExpandProperty AbsolutePath) -match '/Roles/GetRole'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'Post' } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs expected result' {

                $response | Select-Object -ExpandProperty property | Should -Be 'value'

            }

            It 'accepts -ID as an alias for -Name' {

                Get-IDRole -ID 'SomeOtherRole' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ([system.uri]::new($URI) | Select-Object -ExpandProperty query) -match 'Name=SomeOtherRole'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}

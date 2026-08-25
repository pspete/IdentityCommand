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

        Context 'GetProfileList' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{
                        'Results' = [pscustomobject]@{
                            'Row' = @(
                                [pscustomobject]@{'property' = 'value' }
                            )
                        }
                    }
                }
                $response = Get-IDAuthenticationProfile
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/AuthProfile/GetDecoratedProfileList'

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

        }

        Context 'GetProfile' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'property' = 'value' }
                }
                $response = Get-IDAuthenticationProfile -Name 'someuuid'
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/AuthProfile/GetProfile'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when object with Uuid is provided via pipe' {

                [pscustomobject]@{'Uuid' = 'otheruuid' } | Get-IDAuthenticationProfile

                # Times 2: one call from the BeforeEach invocation above, one from the pipe call here
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/AuthProfile/GetProfile'

                } -Times 2 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty uuid) -eq 'someuuid'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}

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
                tenant_url = $null
                TenantId   = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'property' = 'value' }
            }

        }

        Context 'SearchKey' {

            BeforeEach {
                $response = New-IDUsernameReminder -tenant_url 'https://somedomain.id.cyberark.cloud/' -SearchKey 'someuser@example.com'
            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint, trimming a trailing slash from tenant_url' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/ForgotUsername'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty SearchKey) -eq 'someuser@example.com'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Interactive' {

            BeforeEach {
                Mock Start-ForgotUsernameSession -MockWith {
                    [pscustomobject]@{
                        'TenantId'   = 'SomeTenant'
                        'SessionId'  = 'somesessionid'
                        'Challenges' = @(
                            [pscustomobject]@{
                                'Mechanisms' = @(
                                    [pscustomobject]@{ 'Name' = 'SQ'; 'MechanismId' = 'somemechanismid' }
                                )
                            }
                        )
                    }
                }
                Mock Get-MechanismAnswer -MockWith { 'someanswer' }
                Mock Complete-ForgotUsernameSession -MockWith {
                    [pscustomobject]@{'property' = 'value' }
                }

                $response = New-IDUsernameReminder -tenant_url 'https://somedomain.id.cyberark.cloud' -Interactive
            }

            It 'starts a forgot username session against the specified tenant' {

                Assert-MockCalled Start-ForgotUsernameSession -ParameterFilter {

                    $TenantUrl -eq 'https://somedomain.id.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

            It 'completes the session using the first returned mechanism' {

                Assert-MockCalled Complete-ForgotUsernameSession -ParameterFilter {

                    $TenantUrl -eq 'https://somedomain.id.cyberark.cloud' -and $TenantId -eq 'SomeTenant' -and $SessionId -eq 'somesessionid'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}

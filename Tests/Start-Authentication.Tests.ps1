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


    AfterAll {

        $Script:RequestBody = $null

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        BeforeEach {
            $Script:Version = '1.0'
            $Script:tenant_url = 'https://somedomain.id.cyberark.cloud'
            $Script:WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
            $LogonRequest = @{ }
            $LogonRequest['Method'] = 'POST'
            $LogonRequest['SessionVariable'] = 'IDSession'
            $LogonRequest['Headers'] = @{'accept' = '*/*' }
            $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

            Mock Invoke-IDRestMethod -MockWith {

            }

        }

        Context 'Input' {

            It 'sends request' {
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/StartAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected Username' {
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.User -eq 'SomeUser'
                } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected Version' {
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Version -eq '1.0'
                } -Times 1 -Exactly -Scope It

            }

            It 'remove WebSession variable from script scope if redirect URL returned' {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'PodFqdn' = 'otherdomain.id.cyberark.cloud' }
                }
                $LogonRequest | Start-Authentication -Credential $Creds
                $Script:WebSession | Should -BeNullOrEmpty
            }

            It 'sets redirect URL as tenant_url' {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'PodFqdn' = 'otherdomain.id.cyberark.cloud' }
                }
                $LogonRequest | Start-Authentication -Credential $Creds
                $Script:tenant_url | Should -Be 'https://otherdomain.id.cyberark.cloud'
            }

            It 'sends two requests if redirect URL returned' {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'PodFqdn' = 'otherdomain.id.cyberark.cloud' }
                }
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -Times 2 -Exactly -Scope It

            }

            It 'sends request to expected first endpoint if redirect URL returned' {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'PodFqdn' = 'otherdomain.id.cyberark.cloud' }
                }
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/StartAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected first endpoint if redirect URL returned' {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'PodFqdn' = 'otherdomain.id.cyberark.cloud' }
                }
                $LogonRequest | Start-Authentication -Credential $Creds
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://otherdomain.id.cyberark.cloud/Security/StartAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'throws on error' {
                Mock Invoke-IDRestMethod -MockWith {
                    throw 'Some Error'
                }
                { $LogonRequest | Start-Authentication -Credential $Creds } | Should -Throw -ExpectedMessage 'Some Error'

            }

        }

        Context 'Output' {

            It 'provides output' {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'data' = 'Values' }
                }

                $LogonRequest | Start-Authentication -Credential $Creds | Should -Not -BeNullOrEmpty

            }

        }

    }

}
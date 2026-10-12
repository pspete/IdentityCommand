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

        Context 'General' {

            BeforeEach {
                $ISPSSSession = [ordered]@{
                    tenant_url         = $null
                    User               = $null
                    TenantId           = $null
                    SessionId          = $null
                    WebSession         = $null
                    StartTime          = $null
                    ElapsedTime        = $null
                    LastCommand        = $null
                    LastCommandTime    = $null
                    LastCommandResults = $null
                    LastError          = $null
                    LastErrorTime      = $null
                }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
                Mock Invoke-IDRestMethod -MockWith {
                    $ISPSSSession.WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                    [pscustomobject]@{
                        token_type   = 'SomeTokenType'
                        expires_in   = 'SomeValue'
                        access_token = 'SomeAccessToken'
                    }
                }

                $Cred = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

            }

            It 'sets expected tenant_url with no trailing slash as script scope variable' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud/ -Credential $Cred
                $Script:ISPSSSession.tenant_url | Should -Be 'https://sometenant.id.cyberark.cloud'
            }

            It 'sends request' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It
            }

            It 'sends request with expected method' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {
                    $Method -eq 'POST'
                }
            }

            It 'sends request with expected content type' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {
                    $ContentType -eq 'application/x-www-form-urlencoded'
                }
            }

            It 'sends request to expected endpoint' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {
                    $URI -eq 'https://sometenant.id.cyberark.cloud/OAuth2/PlatformToken'
                }
            }

            It 'sends request with expected body' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {

                    $RequestBody = $Body
                    $RequestBody.grant_type -eq 'client_credentials'

                }

                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {

                    $RequestBody = $Body
                    $RequestBody.client_id -eq 'SomeUser'

                }

                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {

                    $RequestBody = $Body
                    $RequestBody.client_secret -eq 'SomePassword'

                }

            }

            It 'provides output' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred | Should -Not -BeNullOrEmpty
            }

            It 'outputs expected object type' {

                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred |
                    Get-Member | Select-Object -ExpandProperty typename -Unique | Should -Be IdCmd.ID.PlatformToken

            }

            It 'outputs object with GetWebSession method' {

                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred |
                    Get-Member -MemberType ScriptMethod | Select-Object -ExpandProperty Name -Unique | Should -Contain GetWebSession

            }

            It 'outputs object with GetToken method' {

                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred |
                    Get-Member -MemberType ScriptMethod | Select-Object -ExpandProperty Name | Should -Contain GetToken

            }

            It 'sets Subdomain from the token subdomain claim' {

                Mock Invoke-IDRestMethod -MockWith {
                    $ISPSSSession.WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                    [pscustomobject]@{
                        token_type   = 'Bearer'
                        access_token = 'eyJhbGciOiJub25lIn0.eyJzdWJkb21haW4iOiJzb21ldGVuYW50In0.c2ln'
                    }
                }

                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                $Script:ISPSSSession.Subdomain | Should -Be 'sometenant'

            }

            It 'sets Subdomain to null when the token is not a JWT' {

                $Script:ISPSSSession.Subdomain = 'stale'
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                $Script:ISPSSSession.Subdomain | Should -BeNullOrEmpty

            }

            It 'leaves no session when sign-in fails' {
                Mock Invoke-IDRestMethod -MockWith { throw 'SomeError' }
                $Script:ISPSSSession.User = 'PreviousUser'
                $Script:ISPSSSession.StartTime = Get-Date
                { New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred } | Should -Throw
                $Script:ISPSSSession.User | Should -BeNullOrEmpty
                $Script:ISPSSSession.StartTime | Should -BeNullOrEmpty
            }

        }

        Context 'Subdomain' {

            BeforeEach {
                $ISPSSSession = [ordered]@{
                    tenant_url = $null
                    Subdomain  = $null
                    User       = $null
                    WebSession = $null
                    StartTime  = $null
                }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
                Mock Resolve-ServiceUrl -MockWith {
                    [pscustomobject]@{
                        ServiceUrl  = 'https://abc1234.id.cyberark.cloud'
                        IdentityUrl = 'https://abc1234.id.cyberark.cloud'
                        ServicePath = ''
                    }
                }
                Mock Invoke-IDRestMethod -MockWith {
                    $ISPSSSession.WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                    [pscustomobject]@{
                        token_type   = 'Bearer'
                        access_token = 'SomeAccessToken'
                    }
                }

                $Cred = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))
            }

            It 'finds the Identity URL of the subdomain from platform discovery' {
                New-IDPlatformToken -tenant_subdomain sometenant -Credential $Cred
                Assert-MockCalled -CommandName Resolve-ServiceUrl -Times 1 -Exactly -Scope It -ParameterFilter {
                    $Service -eq 'identity_user_portal' -and $Subdomain -eq 'sometenant'
                }
            }

            It 'sends request to the discovered Identity URL' {
                New-IDPlatformToken -subdomain sometenant -Credential $Cred
                Assert-MockCalled -CommandName Invoke-IDRestMethod -Times 1 -Exactly -Scope It -ParameterFilter {
                    $URI -eq 'https://abc1234.id.cyberark.cloud/OAuth2/PlatformToken'
                }
            }

            It 'sets Subdomain from the parameter when the token has no subdomain claim' {
                New-IDPlatformToken -tenant_subdomain sometenant -Credential $Cred
                $Script:ISPSSSession.Subdomain | Should -Be 'sometenant'
            }

            It 'sets Subdomain from the token subdomain claim when present' {
                Mock Invoke-IDRestMethod -MockWith {
                    $ISPSSSession.WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                    [pscustomobject]@{
                        token_type   = 'Bearer'
                        access_token = 'eyJhbGciOiJub25lIn0.eyJzdWJkb21haW4iOiJzb21ldGVuYW50In0.c2ln'
                    }
                }
                New-IDPlatformToken -tenant_subdomain SomeTenant -Credential $Cred
                $Script:ISPSSSession.Subdomain | Should -BeExactly 'sometenant'
            }

            It 'does not use platform discovery when tenant_url is provided' {
                New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Cred
                Assert-MockCalled -CommandName Resolve-ServiceUrl -Times 0 -Exactly -Scope It
            }

        }

    }

}
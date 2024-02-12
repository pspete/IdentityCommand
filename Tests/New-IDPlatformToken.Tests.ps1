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
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{
                    token_type   = 'SomeTokenType'
                    expires_in   = 'SomeValue'
                    access_token = 'SomeAccessToken'
                }
            }

            $Cred = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

        }

        Context 'General' {

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

        }

    }

}
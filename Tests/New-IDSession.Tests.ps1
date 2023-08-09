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

            Mock Start-Authentication -MockWith {
                [pscustomobject]@{
                    TenantId         = 'SomeID'
                    SessionId        = 'SomeSession'
                    Challenges       = @(
                        [pscustomobject]@{
                            Mechanisms = @(
                                [pscustomobject]@{
                                    Name = 'SomeName'
                                }
                            )
                        }
                    )
                    Summary          = 'NewPackage'
                    EventDescription = 'SomeEvent'
                }
            }

            Mock Start-AdvanceAuthentication -MockWith {}
            Mock Write-Warning -MockWith {}
            Mock Write-Host {}

            Mock Select-ChallengeMechanism -MockWith {
                [pscustomobject]@{
                    Name             = 'SomeName'
                    AnswerType       = 'SomeType'
                    PromptSelectMech = 'Answer'
                    PromptMechChosen = 'Enter Answer'
                    MechanismId      = 'SomeMechID'
                }
            }

            Mock Get-MechanismAnswer -MockWith {
                Write-Output 'Some Answer'
            }

            $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

        }

        Context 'General' {

            It 'sets expected tenant_url with no trailing slash as script scope variable' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud/ -Credential $Creds
                $Script:tenant_url | Should -Be 'https://somedomain.id.cyberark.cloud'

            }

            It 'sets expected Version as script scope variable' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                $Script:Version | Should -Be '1.0'

            }

        }

        Context 'Start-Authentication' {

            It 'sends Start-Authentication request with expected credential' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                Assert-MockCalled -CommandName Start-Authentication -Times 1 -Exactly -Scope It -ParameterFilter {

                    $Credential -eq $Creds

                }

            }

            It 'sends Start-Authentication request with expected method' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                Assert-MockCalled -CommandName Start-Authentication -Times 1 -Exactly -Scope It -ParameterFilter {

                    $LogonRequest['Method'] -eq 'POST'

                }

            }

            It 'sends Start-Authentication request with expected accept header' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                Assert-MockCalled -CommandName Start-Authentication -Times 1 -Exactly -Scope It -ParameterFilter {

                    $LogonRequest['Headers']['Accept'] -eq '*/*'

                }

            }

            It 'sets expected tenantId with no trailing slash as script scope variable' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                $Script:tenantId | Should -Be 'SomeID'

            }

            It 'sets expected sessionId as script scope variable' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                $Script:sessionId | Should -Be 'SomeSession'

            }

        }

        Context 'Start-AdvanceAuthentication' {

            It 'evaluates single challenge' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                Assert-MockCalled -CommandName Start-AdvanceAuthentication -Times 1 -Exactly -Scope It

            }

            It 'writes event description as warning' {
                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds
                Assert-MockCalled -CommandName Write-Warning -Times 1 -Exactly -Scope It -ParameterFilter {
                    $Message -eq 'SomeEvent'
                }
            }

            It 'evaluates multiple challenges' {

                Mock Start-Authentication -MockWith {
                    [pscustomobject]@{
                        TenantId         = 'SomeID'
                        SessionId        = 'SomeSession'
                        Challenges       = @(
                            [pscustomobject]@{
                                Mechanisms = @(
                                    [pscustomobject]@{
                                        Name = 'SomeName'
                                    }
                                )
                            },
                            [pscustomobject]@{
                                Mechanisms = @(
                                    [pscustomobject]@{
                                        Name = 'SomeName'
                                    }
                                )
                            }

                        )
                        Summary          = 'NewPackage'
                        EventDescription = 'SomeEvent'
                    }
                }

                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds

                Assert-MockCalled -CommandName Start-AdvanceAuthentication -Times 2 -Exactly -Scope It

            }

            It 'throws if advance authentication fails' {
                Mock Start-AdvanceAuthentication -MockWith {
                    throw 'Some Failure'
                }

                { New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds } |
                    Should -Throw -ExpectedMessage 'Some Failure'

            }

            It 'throws if mechanism answer process is not successful' {
                Mock Get-MechanismAnswer -MockWith {
                    throw 'Answer Failure'
                }

                { New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds } |
                    Should -Throw -ExpectedMessage 'Answer Failure'

            }

        }

        Context 'Output' {

            BeforeEach {
                Mock Start-AdvanceAuthentication -MockWith {
                    [pscustomobject]@{
                        Summary = 'LoginSuccess'
                    }
                }
            }
            It 'displys expected message on NonCommitalSuccess' {

                Mock Start-AdvanceAuthentication -MockWith {
                    [pscustomobject]@{
                        Summary       = 'NoncommitalSuccess'
                        ClientMessage = 'Some Message'
                    }
                }

                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds | Should -BeNullOrEmpty
                Assert-MockCalled -CommandName Write-Host -Times 1 -Exactly -Scope It -ParameterFilter {
                    $Message -eq 'Some Message'
                }

            }

            It 'outputs expected object type on LoginSuccess' {

                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds |
                    Get-Member | Select-Object -ExpandProperty typename -Unique | Should -Be IdCmd.ID.Session

            }

            It 'outputs object with GetWebSession method' {

                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds |
                    Get-Member -MemberType ScriptMethod | Select-Object -ExpandProperty Name -Unique | Should -Contain GetWebSession

            }

            It 'outputs object with GetBearerToken method' {

                New-IDSession -tenant_url https://somedomain.id.cyberark.cloud -Credential $Creds |
                    Get-Member -MemberType ScriptMethod | Select-Object -ExpandProperty Name | Should -Contain GetBearerToken

            }

        }

    }

}
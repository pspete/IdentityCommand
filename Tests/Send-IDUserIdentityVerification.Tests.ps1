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

            #Select-ChallengeMechanism only prompts interactively when more than one mechanism is
            #passed to it - mock it here so tests don't hang on a real PromptForChoice
            Mock Select-ChallengeMechanism -MockWith {

                $Mechanisms[0]

            }

            Mock Get-MechanismAnswer -MockWith {

                ConvertTo-SecureString -String 'somecode' -AsPlainText -Force

            }

        }

        Context 'OOB mechanism (e.g. EMAIL)' {

            BeforeEach {

                Mock Start-IdentityVerification -MockWith {
                    [pscustomobject]@{
                        ReturnData = [pscustomobject]@{
                            SessionId  = 'somesessionid'
                            Challenges = @(
                                [pscustomobject]@{
                                    Mechanisms = @(
                                        [pscustomobject]@{ Name = 'EMAIL'; MechanismId = 'someemailmechanismid'; AnswerType = 'StartTextOob' }
                                    )
                                }
                            )
                        }
                    }
                }

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ Summary = 'OobPending' }
                } -ParameterFilter { ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).Action -eq 'StartOOB' }

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ Summary = 'LoginSuccess' }
                } -ParameterFilter { ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).Action -eq 'Poll' }

                Mock Start-Sleep -MockWith {}

                $script:response = Send-IDUserIdentityVerification -ID 'someuserid'

            }

            It 'starts the identity verification challenge' {

                Assert-MockCalled Start-IdentityVerification -ParameterFilter {

                    $ID -eq 'someuserid'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/SendIdentityVerification' -and $Method -eq 'POST'

                } -Times 2 -Exactly -Scope It

            }

            It 'first sends Action StartOOB with the chosen mechanism, session and tenant' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $Parsed.UUID -eq 'someuserid' -and
                    $Parsed.MechanismId -eq 'someemailmechanismid' -and
                    $Parsed.SessionId -eq 'somesessionid' -and
                    $Parsed.Action -eq 'StartOOB' -and
                    $Parsed.TenantId -eq 'SomeTenant'
                } -Times 1 -Exactly -Scope It

            }

            It 'then polls until no longer pending' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).Action -eq 'Poll'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $script:response | Should -Not -BeNullOrEmpty
                $script:response.Summary | Should -Be 'LoginSuccess'

            }

        }

        Context 'Direct-answer mechanism (e.g. OATH)' {

            BeforeEach {

                Mock Start-IdentityVerification -MockWith {
                    [pscustomobject]@{
                        ReturnData = [pscustomobject]@{
                            SessionId  = 'somesessionid'
                            Challenges = @(
                                [pscustomobject]@{
                                    Mechanisms = @(
                                        [pscustomobject]@{ Name = 'OATH'; MechanismId = 'someoathmechanismid'; AnswerType = 'Text' }
                                    )
                                }
                            )
                        }
                    }
                }

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ Summary = 'LoginSuccess' }
                }

                $script:response = Send-IDUserIdentityVerification -ID 'someuserid'

            }

            It 'collects an answer for the mechanism' {

                Assert-MockCalled Get-MechanismAnswer -Times 1 -Exactly -Scope It

            }

            It 'sends Action Answer' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).Action -eq 'Answer'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Multiple mechanisms enrolled' {

            BeforeEach {

                Mock Start-IdentityVerification -MockWith {
                    [pscustomobject]@{
                        ReturnData = [pscustomobject]@{
                            SessionId  = 'somesessionid'
                            Challenges = @(
                                [pscustomobject]@{
                                    Mechanisms = @(
                                        [pscustomobject]@{ Name = 'OTP'; MechanismId = 'someotpmechanismid'; AnswerType = 'StartTextOob' },
                                        [pscustomobject]@{ Name = 'EMAIL'; MechanismId = 'someemailmechanismid'; AnswerType = 'StartTextOob' },
                                        [pscustomobject]@{ Name = 'OATH'; MechanismId = 'someoathmechanismid'; AnswerType = 'Text' }
                                    )
                                }
                            )
                        }
                    }
                }

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ Summary = 'LoginSuccess' }
                }

                $script:response = Send-IDUserIdentityVerification -ID 'someuserid'

            }

            It 'calls Select-ChallengeMechanism exactly once with the full mechanism list' {

                #Piping the array here instead of passing -Mechanisms would call this once per
                #mechanism (each seeing a count of 1) rather than once with all three - this is
                #what a live test against a user with 3 enrolled factors actually caught
                Assert-MockCalled Select-ChallengeMechanism -ParameterFilter {

                    $Mechanisms.Count -eq 3

                } -Times 1 -Exactly -Scope It

            }

            It 'sends a single MechanismId, not an array of all mechanisms'' IDs' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $Parsed.MechanismId -eq 'someotpmechanismid'
                } -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $Parsed.MechanismId -is [Array]
                } -Times 0 -Exactly -Scope It

            }

        }

        Context 'Input validation' {

            It 'throws when the user has no enrolled mechanisms' {

                Mock Start-IdentityVerification -MockWith {
                    [pscustomobject]@{
                        ReturnData = [pscustomobject]@{
                            SessionId  = 'somesessionid'
                            Challenges = @()
                        }
                    }
                }

                { Send-IDUserIdentityVerification -ID 'someuserid' } | Should -Throw

            }

        }

    }

}

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
                tenant_url = 'https://somedomain.id.cyberark.cloud'
                TenantId   = 'SomeTenant'
                SessionId  = 'somesessionid'
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Unprotect-Answer -MockWith { 'PlainAnswer' }

        }

        Context 'With a challenge to answer' {

            BeforeEach {
                Mock Invoke-IDRestMethod -ParameterFilter { $URI -like '*StartChallenge*' } -MockWith {
                    [pscustomobject]@{
                        'Challenges' = @(
                            [pscustomobject]@{
                                'Mechanisms' = @(
                                    [pscustomobject]@{ 'Name' = 'SQ'; 'MechanismId' = 'somemechanismid' }
                                )
                            }
                        )
                    }
                }
                Mock Invoke-IDRestMethod -ParameterFilter { $URI -like '*ChallengeUser*' } -MockWith {
                    [pscustomobject]@{'property' = 'value' }
                }
                Mock Get-MechanismAnswer -MockWith { ConvertTo-SecureString 'someanswer' -AsPlainText -Force }

                $response = New-IDStepUpChallenge
            }

            It 'starts the challenge' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/StartChallenge'

                } -Times 1 -Exactly -Scope It

            }

            It 'answers the challenge using the mechanism name as profileName' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/ChallengeUser?profileName=SQ'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'With no challenge to answer' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ 'Challenges' = @() }
                }

                $response = New-IDStepUpChallenge
            }

            It 'returns the raw response without attempting to answer' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It
                $response.Challenges.Count | Should -Be 0

            }

        }

    }

}

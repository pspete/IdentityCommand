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

        Context 'Standard Operation' {
            BeforeEach {

                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'SomeAnswerType'
                    Name        = 'SomeMechanism'
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

            }

            It 'throws if Mechanism not supported by module' {
                { Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds } | Should -Throw
            }

        }

        Context 'User Passwords' {

            BeforeEach {

                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'SomeAnswerType'
                    Name        = 'UP'
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

            }

            It 'automatically uses credential secure string password as answer for UP mechanism' {

                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds | Should -Be -ExpectedValue System.Security.SecureString
            }

            It 'uses expected password value in response to UP mechanism' {

                $answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Unprotect-Answer $answer | Should -Be 'SomePassword'
            }
        }

        Context 'Security Questions' {

            BeforeEach {
                $Mechanism = [pscustomobject]@{
                    'Name'               = 'SQ'
                    'AnswerType'         = 'Text'
                    'MultipartMechanism' = [pscustomobject]@{
                        'PromptSelectMech' = 'Security Question'
                        'MechanismParts'   = @(
                            [pscustomobject]@{
                                'Uuid'             = 'Uuid1'
                                'QuestionText'     = 'Question 1?'
                                'PromptMechChosen' = 'Answer security question Question 1?'
                            },
                            [pscustomobject]@{
                                'Uuid'             = 'Uuid2'
                                'QuestionText'     = 'Question 2?'
                                'PromptMechChosen' = 'Answer security question Question 2?'
                            }
                        )
                    }
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))
            }
            It 'prompts for answers to security questions' {
                Mock -CommandName Read-Host -MockWith {}
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds

                Assert-MockCalled -CommandName Read-Host -Times 2 -Scope It -Exactly
                Assert-MockCalled -CommandName Read-Host -Times 1 -Scope It -Exactly -ParameterFilter {
                    $Prompt -eq 'Answer security question Question 1?'
                }
                Assert-MockCalled -CommandName Read-Host -Times 1 -Scope It -Exactly -ParameterFilter {
                    $Prompt -eq 'Answer security question Question 2?'
                }
            }

            It 'provides expected responses for expected  response parts' {
                Mock -CommandName Read-Host -MockWith {
                    if ($script:iteration -le 1) {
                        $(ConvertTo-SecureString 'SomeAnswer1' -AsPlainText -Force)
                        $script:iteration++
                    } else {
                        $(ConvertTo-SecureString 'SomeAnswer2' -AsPlainText -Force)
                    }
                }
                $script:iteration = 1
                $answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Read-Host -Times 2 -Scope It -Exactly

                $output = Unprotect-Answer $answer
                $output['Uuid1'] | Should -Be 'SomeAnswer1'
                $output['Uuid2'] | Should -Be 'SomeAnswer2'
            }

        }

        Context 'OOB Poll' {
            BeforeEach {
                $Mechanism = [pscustomobject]@{
                    Name             = 'QR'
                    PromptMechChosen = 'SomeQRMessage'
                    Image            = 'SomeImageData'
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

                Mock Write-Host -MockWith {}
            }

            It 'displays expected message for Email Mechanisms' {
                $Mechanism = [pscustomobject]@{
                    Name             = 'EMAIL'
                    PromptMechChosen = 'SomeEmailMessage'
                }
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Write-Host -Times 1 -ParameterFilter {
                    $Object -eq 'SomeEmailMessage'
                } -Scope It -Exactly
            }

            It 'displays expected message for OTP Mechanisms' {
                $Mechanism = [pscustomobject]@{
                    Name             = 'OTP'
                    PromptMechChosen = 'SomeOTPMessage'
                }
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Write-Host -Times 1 -ParameterFilter {
                    $Object -eq 'SomeOTPMessage'
                } -Scope It -Exactly
            }

            It 'displays expected message for PF Mechanisms' {
                $Mechanism = [pscustomobject]@{
                    Name             = 'PF'
                    PromptMechChosen = 'SomePFMessage'
                }
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Write-Host -Times 1 -ParameterFilter {
                    $Object -eq 'SomePFMessage'
                } -Scope It -Exactly
            }

            It 'displays expected message for QR Mechanisms' {
                Mock Out-QRImage -MockWith {}
                Mock Invoke-Item -MockWith {}
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Write-Host -Times 1 -ParameterFilter {
                    $Object -eq 'SomeQRMessage'
                } -Scope It -Exactly
            }


            It 'creates expected QR Image' {
                Mock Out-QRImage -MockWith {}
                Mock Invoke-Item -MockWith {}
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Out-QRImage -Times 1 -ParameterFilter {
                    $Image -eq 'SomeImageData'
                } -Scope It -Exactly
            }


            It 'attempts to open expected QR Image' {
                Mock Out-QRImage -MockWith { Write-Output 'SomePath' }
                Mock Invoke-Item -MockWith {}
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Invoke-Item -Times 1 -ParameterFilter {
                    $Path -eq 'SomePath'
                } -Scope It -Exactly
            }

        }

        Context 'OOB Answerable' {
            BeforeEach {
                $Mechanism = [pscustomobject]@{
                    Name             = 'SMS'
                    PromptMechChosen = 'SomeMessage'
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

                Mock Read-Host -MockWith { $(ConvertTo-SecureString 'SomeAnswer' -AsPlainText -Force) }
            }

            It 'prompts for SMS OTP answer' {
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Read-Host -Times 1 -ParameterFilter {
                    $Prompt -eq 'SomeMessage'
                } -Scope It -Exactly
            }

            It 'outputs expected SMS OTP answer' {

                $answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Unprotect-Answer $answer | Should -Be 'SomeAnswer'

            }

            It 'prompts for OATH OTP answer' {
                $Mechanism = [pscustomobject]@{
                    Name             = 'OATH'
                    PromptMechChosen = 'SomeMessage'
                }
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Read-Host -Times 1 -ParameterFilter {
                    $Prompt -eq 'SomeMessage'
                } -Scope It -Exactly
            }

            It 'outputs expected OATH OTP answer' {
                $Mechanism = [pscustomobject]@{
                    Name             = 'OATH'
                    PromptMechChosen = 'SomeMessage'
                }
                $answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Unprotect-Answer $answer | Should -Be 'SomeAnswer'
            }
        }

        Context 'Expired Password' {
            BeforeEach {
                $Mechanism = [pscustomobject]@{
                    Name                   = 'RESET'
                    PasswordComplexityHint = 'More Cowbell'
                }
                $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

                Mock Read-Host -MockWith { $(ConvertTo-SecureString 'SomeAnswer' -AsPlainText -Force) }
                Mock Write-Host -MockWith {}
                Mock Write-Warning -MockWith { Write-Output 'Passwords did not match, please try again.' }
            }

            It 'displays complexity hint' {
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Write-Host -Times 1 -ParameterFilter {
                    $Message -eq 'More Cowbell'
                } -Scope It -Exactly
            }
            It 'prompts for new password' {
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Read-Host -Times 1 -ParameterFilter {
                    $Prompt -eq 'Password'
                } -Scope It -Exactly
            }

            It 'prompts for new password confirmation' {
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled -CommandName Read-Host -Times 1 -ParameterFilter {
                    $Prompt -eq 'Confirm Password'
                } -Scope It -Exactly
            }

            It 'warns if entered password secure string values do not match' {
                Mock -CommandName Read-Host -MockWith {
                    if ($script:iteration -le 1) {
                        $(ConvertTo-SecureString 'SomeAnswer1' -AsPlainText -Force)
                        $script:iteration++
                    } else {
                        $(ConvertTo-SecureString 'SomeAnswer2' -AsPlainText -Force)
                    }
                }
                $script:iteration = 1
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled Write-Warning -Times 1 -ParameterFilter {
                    $Message -eq 'Passwords did not match, please try again.'
                } -Scope It -Exactly
            }

            It 'reprompts if entered password secure string values do not match' {
                Mock -CommandName Read-Host -MockWith {
                    if ($script:iteration -le 1) {
                        $(ConvertTo-SecureString 'SomeAnswer1' -AsPlainText -Force)
                        $script:iteration++
                    } elseif ($script:iteration -eq 2) {
                        $(ConvertTo-SecureString 'SomeAnswer2' -AsPlainText -Force)
                    } else {
                        $(ConvertTo-SecureString 'SomeAnswer3' -AsPlainText -Force)
                    }
                }
                $script:iteration = 1
                Get-MechanismAnswer -Mechanism $Mechanism -Credential $Creds
                Assert-MockCalled Read-Host -Times 2 -ParameterFilter {
                    $Prompt -eq 'Password'
                } -Scope It -Exactly
                Assert-MockCalled Read-Host -Times 2 -ParameterFilter {
                    $Prompt -eq 'Confirm Password'
                } -Scope It -Exactly

            }

        }

    }

}

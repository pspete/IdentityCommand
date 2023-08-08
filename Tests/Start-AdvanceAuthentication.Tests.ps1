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
            $Script:TenantId = 'SomeTenant'
            $Script:SessionId = 'SomeSession'
            $Mechanism = [pscustomobject]@{
                MechanismId = 'SomeMechanismId'
                AnswerType  = 'Text'
                Name        = 'Email'
            }
            $LogonRequest = @{ }
            $LogonRequest['Method'] = 'POST'
            $LogonRequest['Headers'] = @{'accept' = '*/*' }
            $LogonRequest['Headers'].Add('X-IDAP-NATIVE-CLIENT', $true)
            $Creds = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))

            Mock Invoke-IDRestMethod -MockWith {}

        }

        Context 'Input' {

            It 'sends request' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/AdvanceAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected TenantId' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.TenantId -eq 'SomeTenant'
                } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected SessionId' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.SessionId -eq 'SomeSession'
                } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected MechanismId' {
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.MechanismId -eq 'SomeMechanismId'
                } -Times 1 -Exactly -Scope It

            }

            It 'throws on error' {
                Mock Invoke-IDRestMethod -MockWith {
                    throw 'Some Error'
                }
                { $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer' } | Should -Throw -ExpectedMessage 'Some Error'

            }

            It 'sends expected request for StartTextOOB answer type' {
                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'StartTextOOB'
                    Name        = 'Email'
                }
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -Times 2 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'StartOOB'
                } -Times 1 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'Poll'
                } -Times 1 -Scope It -Exactly
            }

            It 'sends expected request for StartOOB answer type' {
                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'StartOOB'
                    Name        = 'PF'
                }
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -Times 2 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'StartOOB'
                } -Times 1 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'Poll'
                } -Times 1 -Scope It -Exactly
            }

            It 'polls while pending OOB response' {
                Mock Invoke-IDRestMethod -MockWith {
                    if ($script:iteration -lt 4) {
                        [pscustomobject]@{
                            'Summary' = 'OobPending'
                        }
                        $script:iteration++
                    } else {
                        [pscustomobject]@{
                            'Summary' = 'LoginSuccess'
                        }
                    }
                }
                $script:iteration = 0
                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'StartTextOOB'
                    Name        = 'OTP'
                }

                Mock Start-Sleep -MockWith {}

                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'
                Assert-MockCalled Invoke-IDRestMethod -Times 5 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'StartOOB'
                } -Times 1 -Scope It -Exactly
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Action -eq 'Poll'
                } -Times 4 -Scope It -Exactly
                Assert-MockCalled Start-Sleep -ParameterFilter {
                    $Seconds -eq 2
                } -Times 3 -Scope It -Exactly
            }

            It 'sends expected request for Answer answer type' {
                $Mechanism = [pscustomobject]@{
                    MechanismId = 'SomeMechanismId'
                    AnswerType  = 'Answer'
                    Name        = 'SQ'
                }

                $Answer = $(ConvertTo-SecureString 'SomeAnswer' -AsPlainText -Force)
                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer $Answer

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.Answer -eq 'SomeAnswer'
                } -Times 1 -Scope It
            }

        }

        Context 'Output' {

            It 'provides output' {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'data' = 'Values' }
                }

                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer' | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Cleanup' {

            It 'invokes Clear-AdvanceAuthentication on error' {
                Mock Invoke-IDRestMethod -MockWith {
                    throw 'Some Error'
                }
                Mock Clear-AdvanceAuthentication -MockWith {}
                { $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer' } | Should -Throw -ExpectedMessage 'Some Error'
                Assert-MockCalled Clear-AdvanceAuthentication -Times 1 -Scope It -Exactly
            }

            It 'removes QR code html page' {

                Mock -CommandName Remove-Item -MockWith {}

                $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer 'SomeAnswer'

                Assert-MockCalled Remove-Item -Times 1 -Scope It -Exactly -ParameterFilter {
                    $Path -eq $(Join-Path $([Environment]::GetEnvironmentVariable('Temp')) 'SomeSession.html')
                }

            }
        }

    }

}
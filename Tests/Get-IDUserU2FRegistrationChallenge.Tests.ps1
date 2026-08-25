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

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'property' = 'value' }
            }

            $response = Get-IDUserU2FRegistrationChallenge -UserDefinedName 'My Token'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/U2f/GetRegistrationChallenge' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body, defaulting -AuthenticatorType to SECURITYKEY' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $BodyObject = $Body | ConvertFrom-Json
                    $BodyObject.userDefinedName -eq 'My Token' -and $BodyObject.authenticatorType -eq 'SECURITYKEY'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends an Origin header matching the tenant URL' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Headers['Origin'] -eq 'https://somedomain.id.cyberark.cloud'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'AuthenticatorType override' {

            BeforeEach {
                Get-IDUserU2FRegistrationChallenge -UserDefinedName 'My Token' -AuthenticatorType 'PLATFORM'
            }

            It 'sends the overridden AuthenticatorType' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty authenticatorType) -eq 'PLATFORM'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}

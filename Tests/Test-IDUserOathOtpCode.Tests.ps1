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

        }

        Context 'Without UseOathDefaults' {

            BeforeEach {
                $response = Test-IDUserOathOtpCode -ID 'someuuid' -OtpCode '123456'
            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Oath/ValidateOtpCode?otpCode=123456&uuid=someuuid'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'With UseOathDefaults' {

            BeforeEach {
                $response = Test-IDUserOathOtpCode -ID 'someuuid' -OtpCode '123456' -UseOathDefaults 'true'
            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Oath/ValidateOtpCode?otpCode=123456&uuid=someuuid&useOathDefaults=true'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}

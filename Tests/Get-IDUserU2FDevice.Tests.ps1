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
                [pscustomobject]@{
                    'IsAggregate' = $false
                    'Count'       = 1
                    'Results'     = @(
                        [pscustomobject]@{
                            'Row' = [pscustomobject]@{ 'KeyHandle' = 'somekeyhandle'; 'UserDefinedName' = 'Some Device' }
                        }
                    )
                    'FullCount'   = 1
                }
            }

        }

        Context 'No Type' {

            BeforeEach {
                $response = Get-IDUserU2FDevice
            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/U2f/GetU2fDevices'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'flattens the RedRock-style envelope to the device rows' {

                $response.KeyHandle | Should -Be 'somekeyhandle'

            }

        }

        Context 'With Type' {

            BeforeEach {
                $response = Get-IDUserU2FDevice -Type 'sometype'
            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/U2f/GetU2fDevicesForUser?type=sometype'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}

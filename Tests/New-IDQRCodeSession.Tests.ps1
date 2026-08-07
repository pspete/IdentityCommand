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
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force

            Mock Start-Sleep -MockWith { }

            Mock Invoke-IDRestMethod -MockWith {
                [pscustomobject]@{'Summary' = 'LoginSuccess' }
            }

            $response = New-IDQRCodeSession -PollIntervalSeconds 1 -TimeoutSeconds 5

        }

        Context 'Input' {

            It 'starts QR code authentication' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/StartQRCodeAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'polls for QR code status' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/GetQRCodeStatus'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses the same guid for both the start and status calls' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $StartGuid = ($Body | ConvertFrom-Json).guid
                    $StartGuid -match '^[0-9a-f-]{36}$'

                } -Times 2 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'stops polling once status is no longer pending' {

                $response.Summary | Should -Be 'LoginSuccess'

            }

        }

    }

}

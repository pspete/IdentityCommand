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

            #The update response is just {State: 0} - Set-IDApplication fetches and returns the
            #updated application via Get-IDApplication instead
            Mock Get-IDApplication -MockWith {
                [pscustomobject]@{ ID = 'someid'; Name = 'SomeName' }
            }

        }

        Context 'State 0 (success)' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'State' = 0 }
                }

                $response = Set-IDApplication -ID 'someid' -Name 'SomeName'

            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/SaasManage/UpdateApplicationDE'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty ID) -eq 'someid'
                } -Times 1 -Exactly -Scope It

            }

            It 'sends _RowKey and PVID alongside ID' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $BodyObject = $Body | ConvertFrom-Json
                    $BodyObject._RowKey -eq 'someid' -and $BodyObject.PVID -eq 'someid'

                } -Times 1 -Exactly -Scope It

            }

            It 'fetches the updated application via Get-IDApplication' {

                Assert-MockCalled Get-IDApplication -ParameterFilter {

                    $ID -eq 'someid'

                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty
                $response.ID | Should -Be 'someid'

            }

        }

        Context 'Non-zero State' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{'State' = 1 }
                }

                $response = Set-IDApplication -ID 'someid' -Name 'SomeName'

            }

            It 'does not fetch the application' {

                Assert-MockCalled Get-IDApplication -Times 0 -Exactly -Scope It

            }

            It 'returns the raw result instead' {

                $response.State | Should -Be 1

            }

        }

    }

}

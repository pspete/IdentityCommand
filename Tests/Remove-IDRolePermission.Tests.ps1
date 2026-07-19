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

            # Remove-IDRolePermission calls Get-IDPermission in its BEGIN block, and both
            # that call and Remove-IDRolePermission's own request now go through
            # Invoke-IDRestMethod, so a single Mock is set up with per-endpoint
            # ParameterFilters to return the right shape for each call.
            Mock Invoke-IDRestMethod -ParameterFilter {
                $URI -match 'redrock/query'
            } -MockWith {
                [pscustomobject]@{
                    'Results' = @(
                        [pscustomobject]@{
                            'Row' = [pscustomobject]@{ 'Path' = '/Path/To/Permission' }
                        }
                    )
                }
            }

            Mock Invoke-IDRestMethod -ParameterFilter {
                $URI -match 'UnAssignSuperRights'
            } -MockWith {
                [pscustomobject]@{'property' = 'value' }
            }

            $response = Remove-IDRolePermission -Name 'SomeRole' -Path '/Path/To/Permission'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 2 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://SomeTenant.id.cyberark.cloud/Roles/UnAssignSuperRights'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -match 'UnAssignSuperRights' -and $Method -match 'Post'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $URI -match 'UnAssignSuperRights' -and
                    $($Body | ConvertFrom-Json | Select-Object -First 1 -ExpandProperty Role) -eq 'SomeRole'
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

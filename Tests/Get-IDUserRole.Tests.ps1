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

        Context 'Input' {

            BeforeEach {
                Mock Invoke-IDRestMethod -MockWith { @{SomeProperty = 'SomeValue' } }
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
                    LastError          = $null
                    LastErrorTime      = $null
                }
                New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
                $response = Get-IDUserRole -ID 1234 -Limit 1 -SortBy String

            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UserMgmt/GetUsersRolesAndAdministrativeRights?ID=1234'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint when object with UUID is provided via pipe' {

                [pscustomobject]@{'Uuid' = 5678 } | Get-IDUserRole

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UserMgmt/GetUsersRolesAndAdministrativeRights?ID=5678'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Body -ne $null } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    ($Body | ConvertFrom-Json | Select-Object -ExpandProperty Args | Select-Object -ExpandProperty Limit) -eq 1
                } -Times 1 -Exactly -Scope It

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                   ($Body | ConvertFrom-Json | Select-Object -ExpandProperty Args | Select-Object -ExpandProperty SortBy) -eq 'String'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides expected output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

    }

}
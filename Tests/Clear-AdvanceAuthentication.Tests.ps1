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
            $Script:TenantId = 'SomeTenant'
            $Script:SessionId = 'SomeSession'
            $Script:tenant_url = 'https://somedomain.id.cyberark.cloud'
            Mock Invoke-IDRestMethod -MockWith {

            }

            $response = Clear-AdvanceAuthentication

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Security/CleanupAuthentication'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected TenantId' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.TenantId -eq 'SomeTenant'
                } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected SessionId' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $RequestBody = $Body | ConvertFrom-Json
                    $RequestBody.SessionId -eq 'SomeSession'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides no output' {

                $response | Should -BeNullOrEmpty

            }

        }

    }

}
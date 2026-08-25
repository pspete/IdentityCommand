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
                    'SecuredItems' = @(
                        [pscustomobject]@{ 'Name' = 'SomeSecuredItem'; 'ItemKey' = 'someitemkey'; 'Icon' = 'data:image/png;base64,aGVsbG8=' }
                    )
                    'Tags'         = @(
                        [pscustomobject]@{ 'tagname' = 'sometag' }
                    )
                    'DefaultTag'   = $null
                }
            }

            $response = Get-IDSecuredItem

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UPRest/GetSecuredItemsData'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $($Body | ConvertFrom-Json | Select-Object -ExpandProperty force) -eq $true
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'includes secured items' {

                $response.SecuredItems | Select-Object -First 1 -ExpandProperty ItemKey | Should -Be 'someitemkey'

            }

            It 'includes tags alongside secured items' {

                $response.Tags | Select-Object -First 1 -ExpandProperty tagname | Should -Be 'sometag'

            }

            It 'lists Tags before SecuredItems so it is not pushed out of view' {

                $response.PSObject.Properties.Name | Select-Object -First 1 | Should -Be 'Tags'

            }

            It 'replaces a raw base64 Icon with a short byte-count summary' {

                $response.SecuredItems | Select-Object -First 1 -ExpandProperty Icon | Should -Be '[image, 5 bytes]'

            }

        }

    }

}

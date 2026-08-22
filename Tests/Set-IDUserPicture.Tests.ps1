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
                '/UserMgmt/GetUserPicture?id=someid'
            } -ParameterFilter { $Method -eq 'POST' }

            Mock Invoke-IDRestMethod -MockWith {

                #Real Invoke-IDRestMethod stashes the full WebResponseObject (including headers)
                #on $ISPSSSession.LastCommandResults - mimic that here so the command under test
                #can read the real Content-Type back out of it.
                $ISPSSSession.LastCommandResults = [PSCustomObject]@{
                    Headers = @{ 'Content-Type' = 'image/png' }
                }

                [Byte[]]@(1, 2, 3, 4)

            } -ParameterFilter { $Method -eq 'GET' }

            $TestFile = Join-Path $TestDrive 'picture.png'
            Set-Content -Path $TestFile -Value 'fake image bytes' -NoNewline

            $response = Set-IDUserPicture -ID 'someid' -Path $TestFile

        }

        Context 'Input' {

            It 'sends the upload request' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Method -eq 'POST' -and $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/SetUserPicture?ID=someid'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends the upload request with a multipart content type' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Method -eq 'POST' -and $ContentType -like 'multipart/form-data; boundary=*'

                } -Times 1 -Exactly -Scope It

            }

            It 'follows the returned path to fetch the picture' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Method -eq 'GET' -and $URI -eq 'https://somedomain.id.cyberark.cloud/UserMgmt/GetUserPicture?id=someid'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides the fetched picture as output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'wraps the picture with its Content-Type' {

                $response.ContentType | Should -Be 'image/png'

            }

            It 'wraps the picture with its Length' {

                $response.Length | Should -Be 4

            }

            It 'exposes the raw picture bytes' {

                ($response.Bytes -join ',') | Should -Be '1,2,3,4'

            }

        }

    }

}

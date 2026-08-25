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
                [pscustomobject]@{'ReturnID' = 'somereturnid' }
            }

            $TestFile = Join-Path $TestDrive 'users.csv'
            Set-Content -Path $TestFile -Value 'Login Name,Email Address' -NoNewline

            $response = Start-UsersCsvUpload -Path $TestFile

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/CDirectoryService/GetUsersFromCsvFile?importType=ImportBulkUser'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with a multipart content type' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $ContentType -like 'multipart/form-data; boundary=*'

                } -Times 1 -Exactly -Scope It

            }

            It 'includes the FileName field and the file itself under Icon' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $Text = [System.Text.Encoding]::UTF8.GetString($Body)
                    ($Text -match 'name="FileName"[\s\S]*?users\.csv') -and
                    ($Text -match 'name="Icon"; filename="users\.csv"') -and
                    ($Text -match 'Content-Type: text/csv')

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'outputs the ReturnID' {

                $response.ReturnID | Should -Be 'somereturnid'

            }

        }

    }

}

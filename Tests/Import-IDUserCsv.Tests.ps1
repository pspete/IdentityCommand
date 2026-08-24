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

            Mock Start-UsersCsvUpload -MockWith {
                [pscustomobject]@{ 'ReturnID' = 'somereturnid' }
            }

            Mock Submit-UsersCsvUpload -MockWith {
                [pscustomobject]@{ 'success' = $true; 'Result' = 'Your job for creating users has been submitted successfully.' }
            }

            $TestFile = Join-Path $TestDrive 'users.csv'
            Set-Content -Path $TestFile -Value 'Login Name,Email Address' -NoNewline

            $response = Import-IDUserCsv -Path $TestFile -AdminEmail 'admin@example.com' -SendEmailInvite

        }

        Context 'Input' {

            It 'uploads the CSV file' {

                Assert-MockCalled Start-UsersCsvUpload -ParameterFilter {

                    $Path -eq $TestFile

                } -Times 1 -Exactly -Scope It

            }

            It 'submits the import using the ReturnID from registration' {

                Assert-MockCalled Submit-UsersCsvUpload -ParameterFilter {

                    $ReturnID -eq 'somereturnid' -and $AdminEmail -eq 'admin@example.com' -and $SendEmailInvite -eq $true

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'shapes the output to Success/Message' {

                $response.Success | Should -Be $true
                $response.Message | Should -Be 'Your job for creating users has been submitted successfully.'

            }

        }

    }

}

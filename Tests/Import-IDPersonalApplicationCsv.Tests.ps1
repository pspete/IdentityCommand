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

            Mock Test-PersonalApplicationCsvImport -MockWith {
                $CredentialsData
            }

            Mock Submit-PersonalApplicationCsvImport -MockWith {
                [pscustomobject]@{ 'property' = 'value' }
            }

            $TestFile = Join-Path $TestDrive 'export.csv'
            @'
name,url,username,password,notes,totp,folder
exampleApp,https://www.examplewebsite.com,exampleuser,SomePassword123,some notes,,a
'@ | Set-Content -Path $TestFile -Encoding UTF8

            $response = Import-IDPersonalApplicationCsv -Path $TestFile

        }

        Context 'Input' {

            It 'parses the CSV and validates it' {

                Assert-MockCalled Test-PersonalApplicationCsvImport -ParameterFilter {

                    $CredentialsData.Count -eq 1 -and
                    $CredentialsData[0].idx -eq 1 -and
                    $CredentialsData[0].name -eq 'exampleApp' -and
                    $CredentialsData[0].username -eq 'exampleuser' -and
                    $CredentialsData[0].password -eq 'SomePassword123' -and
                    $CredentialsData[0].folder -eq 'a' -and
                    $CredentialsData[0].isValid -eq $true -and
                    $CredentialsData[0].duplicate -eq $false

                } -Times 1 -Exactly -Scope It

            }

            It 'submits the validated data with the file name, defaulting skip flags to $false' {

                Assert-MockCalled Submit-PersonalApplicationCsvImport -ParameterFilter {

                    $CredFileName -eq 'export.csv' -and $CredentialsData.Count -eq 1 -and
                    $SkipIfAppExists -eq $false -and $SkipSharedFolders -eq $false

                } -Times 1 -Exactly -Scope It

            }

            It 'allows overriding skip flags' {

                Import-IDPersonalApplicationCsv -Path $TestFile -SkipIfAppExists $true -SkipSharedFolders $true | Out-Null

                Assert-MockCalled Submit-PersonalApplicationCsvImport -ParameterFilter {

                    $SkipIfAppExists -eq $true -and $SkipSharedFolders -eq $true

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'shapes the output to Success/SubmittedCount' {

                $response.Success | Should -Be $true
                $response.SubmittedCount | Should -Be 1

            }

        }

    }

}

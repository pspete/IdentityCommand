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
                [pscustomobject]@{'property' = 'value' }
            }

            $CredentialsData = @(@{ idx = 1; name = 'exampleApp' })

            $response = Submit-PersonalApplicationCsvImport -CredentialsData $CredentialsData -CredFileName 'export.csv'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/uprest/ImportUserCredentials' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body, defaulting CredentialProvider/skip flags' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $Parsed.credFileName -eq 'export.csv' -and
                    $Parsed.credentialProvider -eq 'Other' -and
                    $Parsed.credentialsData[0].name -eq 'exampleApp' -and
                    $Parsed.skipIfAppExists -eq $false -and
                    $Parsed.skipSharedFolders -eq $false
                } -Times 1 -Exactly -Scope It

            }

            It 'allows overriding CredentialProvider/skip flags' {

                Submit-PersonalApplicationCsvImport -CredentialsData $CredentialsData -CredFileName 'export.csv' -CredentialProvider 'LastPass' -SkipIfAppExists $true -SkipSharedFolders $true | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $Parsed.credentialProvider -eq 'LastPass' -and
                    $Parsed.skipIfAppExists -eq $true -and
                    $Parsed.skipSharedFolders -eq $true
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

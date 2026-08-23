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

            $response = Set-IDTenantConfiguration -CompanyName 'SomeCompany' -CompanySupportLink 'https://example.com/support'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/TenantConfig/SetCustomerConfig' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    $BodyObject.CompanyName -eq 'SomeCompany' -and $BodyObject.CompanySupportLink -eq 'https://example.com/support'
                } -Times 1 -Exactly -Scope It

            }

            It 'only sends fields actually supplied' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    ($Body | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'ThemeColor'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Array and typed parameters' {

            BeforeEach {
                Set-IDTenantConfiguration -AllowCors @('https://example.com') -OtpCodeLength 6 -EnableQRCode $true
            }

            It 'sends arrays and typed values correctly' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    (@($BodyObject.AllowCors) -contains 'https://example.com') -and
                    $BodyObject.OtpCodeLength -eq 6 -and
                    $BodyObject.EnableQRCode -eq $true
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'AdditionalSettings' {

            BeforeEach {
                Set-IDTenantConfiguration -AdditionalSettings @{ 'SomeUndocumentedField' = 'SomeValue' }
            }

            It 'merges in the additional settings as literal field names' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    ($BodyObject.PSObject.Properties.Name -contains 'SomeUndocumentedField') -and
                    $BodyObject.SomeUndocumentedField -eq 'SomeValue'
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

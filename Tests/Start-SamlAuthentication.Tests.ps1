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
            $Script:Version = '1.0'

            $ISPSSSession = [ordered]@{
                tenant_url         = 'https://somedomain.id.cyberark.cloud'
                User               = $null
                TenantId           = $null
                SessionId          = $null
                WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime          = $null
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = $null
                LastCommandResults = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            $LogonRequest = @{ }
            $LogonRequest['Method'] = 'POST'
            $LogonRequest['SessionVariable'] = 'IDSession'
            $LogonRequest['Headers'] = @{'accept' = '*/*' }
            $SamlResponse = 'SomeSamlResponse'

            Mock Invoke-IDRestMethod -MockWith {

            }

        }

        Context 'Input' {

            It 'sends request' {
                $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse
                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {
                $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/my'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {
                $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends body with expected SamlResponse' {
                $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse
                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Body.SamlResponse -eq 'SomeSamlResponse'
                } -Times 1 -Exactly -Scope It

            }

            It 'throws on error' {
                Mock Invoke-IDRestMethod -MockWith {
                    throw 'Some Error'
                }
                { $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse } | Should -Throw -ExpectedMessage 'Some Error'

            }

        }

        Context 'Output' {

            It 'provides no output' {

                Mock Invoke-IDRestMethod -MockWith {

                }

                $LogonRequest | Start-SamlAuthentication -SamlResponse $SamlResponse | Should -BeNullOrEmpty

            }

        }

    }

}
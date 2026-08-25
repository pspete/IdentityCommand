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
                'someitemkey'
            }

            $SecurePassword = ConvertTo-SecureString -String 'somepassword' -AsPlainText -Force

            $response = New-IDSecuredItem -Name 'SomeItem' -SecuredItemType 'Password' -Username 'someuser' -Password $SecurePassword

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UPRest/AddSecuredItem' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $BodyObject = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $BodyObject.Name -eq 'SomeItem' -and
                    $BodyObject.SecuredItemType -eq 'Password' -and
                    $BodyObject.Username -eq 'someuser' -and
                    $BodyObject.Password -eq 'somepassword'

                } -Times 1 -Exactly -Scope It

            }

            It 'only sends optional fields actually supplied' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    ([System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json).PSObject.Properties.Name -notcontains 'Description'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'SecureNote' {

            BeforeEach {
                New-IDSecuredItem -Name 'SomeNote' -SecuredItemType 'SecureNote' -Notes 'Some note content'
            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $BodyObject = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $BodyObject.SecuredItemType -eq 'SecureNote' -and $BodyObject.Notes -eq 'Some note content'

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}

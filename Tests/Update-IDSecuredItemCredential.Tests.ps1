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

            $response = Update-IDSecuredItemCredential -ItemKey 'someitemkey' -Username 'someuser'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UPRest/UpdateCredsForSecuredItem?sItemkey=someitemkey'

                } -Times 1 -Exactly -Scope It

            }

            It 'only sends fields actually supplied' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $BodyObject = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    $BodyProperties = $BodyObject.PSObject.Properties.Name
                    ($BodyProperties -contains 'Username') -and
                    -not ($BodyProperties -contains 'CustomFields') -and
                    -not ($BodyProperties -contains 'Notes') -and
                    -not ($BodyProperties -contains 'ItemKey')

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'CustomFields' {

            It 'sends confirmed field names, defaulting Hidden to $false' {

                Update-IDSecuredItemCredential -ItemKey 'someitemkey' -CustomFields @{ Key = 'zzzTest'; Value = 'testing' } | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    ($Parsed.PSObject.Properties.Name -contains 'CustomFields') -and
                    $Parsed.CustomFields[0].CustomFields_Key -eq 'zzzTest' -and
                    $Parsed.CustomFields[0].CustomFields_Value -eq 'testing' -and
                    $Parsed.CustomFields[0].CustomFields_IsHidden -eq $false
                } -Times 1 -Exactly -Scope It

            }

            It 'sends an explicit Hidden value' {

                Update-IDSecuredItemCredential -ItemKey 'someitemkey' -CustomFields @{ Key = 'zzzTest'; Value = 'testing'; Hidden = $true } | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    ($Parsed.PSObject.Properties.Name -contains 'CustomFields') -and
                    $Parsed.CustomFields[0].CustomFields_IsHidden -eq $true
                } -Times 1 -Exactly -Scope It

            }

            It 'sends multiple fields' {

                Update-IDSecuredItemCredential -ItemKey 'someitemkey' -CustomFields @{ Key = 'first'; Value = '1' }, @{ Key = 'second'; Value = '2' } | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = [System.Text.Encoding]::UTF8.GetString($Body) | ConvertFrom-Json
                    ($Parsed.PSObject.Properties.Name -contains 'CustomFields') -and
                    $Parsed.CustomFields.Count -eq 2 -and
                    $Parsed.CustomFields[1].CustomFields_Key -eq 'second'
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

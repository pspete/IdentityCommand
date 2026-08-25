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

            Mock Invoke-IDSqlcmd -MockWith {
                [pscustomobject]@{ Guid = 'someuserid'; Username = 'someuser@somedomain.com'; DisplayName = 'Some User' }
            }

            $response = Get-IDOrganizationMember -ID 'someorgid'

        }

        Context 'Input' {

            It 'sends a query scoped to the organization' {

                Assert-MockCalled Invoke-IDSqlcmd -ParameterFilter {

                    $Script -eq "SELECT ID as Guid, Username, DisplayName FROM User WHERE OrgId = 'someorgid'"

                } -Times 1 -Exactly -Scope It

            }

            It 'escapes embedded single quotes in -ID' {

                Get-IDOrganizationMember -ID "some'orgid" | Out-Null

                Assert-MockCalled Invoke-IDSqlcmd -ParameterFilter {

                    $Script -eq "SELECT ID as Guid, Username, DisplayName FROM User WHERE OrgId = 'some''orgid'"

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

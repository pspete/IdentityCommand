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
                @(
                    [pscustomobject]@{ ObjectType = 'Row'; PrincipalType = 'User'; PrincipalName = 'directuser'; Inherited = $false; Grant = 2147483780; GrantStr = '0' }
                    [pscustomobject]@{ ObjectType = 'TableRow'; PrincipalType = 'User'; PrincipalName = 'inheriteduser'; Inherited = $true; Grant = 93; GrantStr = '0'; Type = 'Super' }
                )
            }

            $response = Get-IDApplicationPermission -ID 'someid'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/Acl/GetRowAces' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.RowKey -eq 'someid' -and $Parsed.Table -eq 'Application' -and $Parsed.ReduceSysadmin -eq $true
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'excludes inherited entries by default' {

                $response.PrincipalName | Should -Not -Contain 'inheriteduser'

            }

            It 'includes direct entries by default' {

                $response.PrincipalName | Should -Contain 'directuser'

            }

            It 'includes inherited entries with -IncludeInherited' {

                $response = Get-IDApplicationPermission -ID 'someid' -IncludeInherited

                $response.PrincipalName | Should -Contain 'inheriteduser'

            }

        }

    }

}

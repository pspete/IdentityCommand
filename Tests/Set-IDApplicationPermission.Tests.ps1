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

            $response = Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -View $true -Execute $true -PrincipalId 'someuserid'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/SaasManage/SetApplicationPermissions'

                } -Times 1 -Exactly -Scope It

            }

            It 'uses expected method' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter { $Method -match 'POST' } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.ID -eq 'someid' -and $Parsed.RowKey -eq 'someid' -and $Parsed.PVID -eq 'someid' -and
                    $Parsed.Grants[0].Principal -eq 'someuser' -and
                    $Parsed.Grants[0].PType -eq 'User' -and
                    $Parsed.Grants[0].PrincipalId -eq 'someuserid'
                } -Times 1 -Exactly -Scope It

            }

            It 'defaults SystemName/ExternalUuid/Type from Principal/PrincipalId/PType' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].SystemName -eq 'someuser' -and
                    $Parsed.Grants[0].ExternalUuid -eq 'someuserid' -and
                    $Parsed.Grants[0].Type -eq 'User'
                } -Times 1 -Exactly -Scope It

            }

            It 'joins the $true right names with a comma, in confirmed order' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View,Execute'
                } -Times 1 -Exactly -Scope It

            }

            It 'allows overriding SystemName/ExternalUuid/Type explicitly' {

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -View $true -PrincipalId 'someuserid' -SystemName 'someothername' -ExternalUuid 'someotherid' -Type 'Role' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].SystemName -eq 'someothername' -and
                    $Parsed.Grants[0].ExternalUuid -eq 'someotherid' -and
                    $Parsed.Grants[0].Type -eq 'Role'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'All confirmed rights' {

            It 'sends every right set to $true in confirmed order' {

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -PrincipalId 'someuserid' -Grant $true -View $true -Admin $true -ViewDetail $true -Delete $true -Execute $true -Automatic $true | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'Grant,View,Admin,ViewDetail,Delete,Execute,Automatic'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Pipeline input by property name' {

            It 'binds right properties from a piped object (e.g. an imported CSV row)' {

                [pscustomobject]@{
                    ID          = 'anotherid'
                    Principal   = 'anotheruser'
                    PType       = 'User'
                    PrincipalId = 'anotheruserid'
                    View        = $true
                    Admin       = $true
                } | Set-IDApplicationPermission | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View,Admin'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Role PType' {

            BeforeEach {

                Set-IDApplicationPermission -ID 'someid' -Principal 'somerole' -PType 'Role' -View $true -PrincipalId 'someroleid' | Out-Null

            }

            It 'does not send SystemName/ExternalUuid for a Role grant' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    ($Parsed.Grants[0].PSObject.Properties.Name -notcontains 'SystemName') -and
                    ($Parsed.Grants[0].PSObject.Properties.Name -notcontains 'ExternalUuid')
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'No rights set to $true' {

            It 'sends Rights of None' {

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -PrincipalId 'someuserid' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'None'
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

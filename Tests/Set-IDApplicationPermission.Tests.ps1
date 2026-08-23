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

            #No existing grant by default - most tests aren't exercising the auto-fetched baseline
            Mock Get-IDApplicationPermission -MockWith { @() }

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

        Context 'No rights, nothing existing' {

            It 'sends Rights of None' {

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -PrincipalId 'someuserid' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'None'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Revoking by explicit $false' {

            It 'removes an existing right when its switch is explicitly $false' {

                Mock Get-IDApplicationPermission -MockWith {
                    @([pscustomobject]@{ Principal = 'revokeuserid'; Rights = @('View', 'Delete') })
                }

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -PrincipalId 'revokeuserid' -Delete $false | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Auto-fetched baseline' {

            It 'calls Get-IDApplicationPermission with -ID when -Rights is not supplied' {

                Set-IDApplicationPermission -ID 'fetchid' -Principal 'fetchuser' -PType 'User' -PrincipalId 'fetchuserid' -Delete $true | Out-Null

                Assert-MockCalled Get-IDApplicationPermission -ParameterFilter { $ID -eq 'fetchid' } -Times 1 -Exactly -Scope It

            }

            It 'does not call Get-IDApplicationPermission when -Rights is supplied explicitly' {

                Set-IDApplicationPermission -ID 'explicitid' -Principal 'explicituser' -PType 'User' -PrincipalId 'explicituserid' -Rights 'View' | Out-Null

                #The outer BeforeEach's default call doesn't supply -Rights, so it triggers one
                #fetch on its own - this call (which does supply -Rights) shouldn't add another
                Assert-MockCalled Get-IDApplicationPermission -ParameterFilter { $ID -eq 'explicitid' } -Times 0 -Exactly -Scope It

            }

            It 'uses the matching principal''s existing Rights as the baseline' {

                Mock Get-IDApplicationPermission -MockWith {
                    @(
                        [pscustomobject]@{ Principal = 'otheruserid'; Rights = @('Admin') }
                        [pscustomobject]@{ Principal = 'matchuserid'; Rights = @('View', 'Execute') }
                    )
                }

                Set-IDApplicationPermission -ID 'someid' -Principal 'matchuser' -PType 'User' -PrincipalId 'matchuserid' -Delete $true | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View,Delete,Execute'
                } -Times 1 -Exactly -Scope It

            }

        }

        Context '-Rights supplied explicitly' {

            It 'includes rights from the baseline that were not explicitly overridden' {

                Set-IDApplicationPermission -ID 'baselineonlyid' -Principal 'baselineonlyuser' -PType 'User' -PrincipalId 'baselineonlyuserid' -Rights 'View', 'Execute' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].PrincipalId -eq 'baselineonlyuserid' -and $Parsed.Grants[0].Rights -eq 'View,Execute'
                } -Times 1 -Exactly -Scope It

            }

            It 'lets an explicit switch override the supplied baseline for that right only' {

                Set-IDApplicationPermission -ID 'someid' -Principal 'someuser' -PType 'User' -PrincipalId 'someuserid' -Rights 'View', 'Execute' -Execute $false -Admin $true | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View,Admin'
                } -Times 1 -Exactly -Scope It

            }

            It 'binds -Rights from a piped object' {

                [pscustomobject]@{
                    ID          = 'baselineid'
                    Principal   = 'baselineuser'
                    PType       = 'User'
                    PrincipalId = 'baselineuserid'
                    Rights      = @('View', 'Delete')
                } | Set-IDApplicationPermission -Admin $true | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.Grants[0].Rights -eq 'View,Admin,Delete'
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

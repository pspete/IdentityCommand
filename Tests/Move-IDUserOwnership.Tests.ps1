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

        }

        Context 'TargetUser' {

            BeforeEach {

                $response = Move-IDUserOwnership -Users 'someuserid' -TargetUser 'someuser@somedomain.com'

            }

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/SaasManage/TransferOwnership' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    (@($BodyObject.Users) -contains 'someuserid') -and
                    $BodyObject.TransferToManager -eq $false -and
                    $BodyObject.TargetUser -eq 'someuser@somedomain.com'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'TransferToManager' {

            BeforeEach {

                $response = Move-IDUserOwnership -Users 'someuserid' -TransferToManager

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    (@($BodyObject.Users) -contains 'someuserid') -and
                    $BodyObject.TransferToManager -eq $true
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Multiple users' {

            It 'sends every supplied user ID' {

                Move-IDUserOwnership -Users 'firstuserid', 'seconduserid' -TargetUser 'someuser@somedomain.com' | Out-Null

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $BodyObject = $Body | ConvertFrom-Json
                    (@($BodyObject.Users) -contains 'firstuserid') -and (@($BodyObject.Users) -contains 'seconduserid')
                } -Times 1 -Exactly -Scope It

            }

        }

    }

}

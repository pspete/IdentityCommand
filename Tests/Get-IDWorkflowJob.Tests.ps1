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
                [pscustomobject]@{
                    Results = [pscustomobject]@{
                        Row = @([pscustomobject]@{ 'property' = 'value' })
                    }
                }
            }

        }

        Context 'All (default)' {

            BeforeEach {
                $response = Get-IDWorkflowJob
            }

            It 'sends request to the tenant-wide endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/JobFlow/GetJobs' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'defaults to Type all, PageNumber 1 and PageSize 100' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.type -eq 'all' -and
                    $Parsed.Args.PageNumber -eq 1 -and
                    $Parsed.Args.PageSize -eq 100 -and
                    $Parsed.Args.Limit -eq 100 -and
                    $Parsed.Args.SortBy -eq 'Description' -and
                    $Parsed.Args.Ascending -eq $true -and
                    $Parsed.Args.Direction -eq 'ASC' -and
                    $Parsed.Args.Caching -eq -1
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty
                $response.property | Should -Be 'value'

            }

        }

        Context 'Mine' {

            BeforeEach {
                $response = Get-IDWorkflowJob -Mine -Type 'approve' -PageNumber 2 -PageSize 50
            }

            It 'sends request to the current user''s endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/JobFlow/GetMyJobs' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.type -eq 'approve' -and
                    $Parsed.Args.PageNumber -eq 2 -and
                    $Parsed.Args.PageSize -eq 50 -and
                    $Parsed.Args.Limit -eq 50
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'Mine, Type request' {

            BeforeEach {
                $response = Get-IDWorkflowJob -Mine -Type 'request'
            }

            It 'sends request with Type request' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.type -eq 'request'
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'JobId' {

            BeforeEach {

                Mock Invoke-IDRestMethod -MockWith {
                    [pscustomobject]@{ ID = 'somejobid'; State = 'Complete' }
                }

                $response = Get-IDWorkflowJob -JobId 'somejobid'

            }

            It 'sends request to the single-job endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/JobFlow/GetJob' -and $Method -eq 'POST'

                } -Times 1 -Exactly -Scope It

            }

            It 'sends request with expected body' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {
                    $Parsed = $Body | ConvertFrom-Json
                    $Parsed.jobid -eq 'somejobid' -and
                    $Parsed.RRFormat -eq $true -and
                    $Parsed.Args.PageNumber -eq 1 -and
                    $Parsed.Args.Limit -eq 1 -and
                    $Parsed.Args.PageSize -eq 1 -and
                    $Parsed.Args.Caching -eq -1
                } -Times 1 -Exactly -Scope It

            }

            It 'provides output without a Results.Row wrapper' {

                $response | Should -Not -BeNullOrEmpty
                $response.ID | Should -Be 'somejobid'

            }

        }

        Context 'Input validation' {

            It 'rejects a -Type value other than all/approve/request' {

                { Get-IDWorkflowJob -Type 'sometype' } | Should -Throw

            }

            It 'rejects -Type approve/request against the tenant-wide endpoint' {

                { Get-IDWorkflowJob -Type 'approve' } | Should -Throw
                { Get-IDWorkflowJob -Type 'request' } | Should -Throw

            }

        }

    }

}

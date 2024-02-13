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
                User               = 'SomeUser'
                TenantId           = 'SomeTenant'
                SessionId          = 'SomeSession'
                WebSession         = New-Object Microsoft.PowerShell.Commands.WebRequestSession
                StartTime          = (Get-Date).AddMinutes(-5)
                ElapsedTime        = $null
                LastCommand        = $null
                LastCommandTime    = (Get-Date).AddMinutes(-1)
                LastCommandResults = @{'TestKey' = 'TestValue' }
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            $response = Get-IDSession

        }

        Context 'General' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

            It 'has output with expected number of properties' {

                $response.Keys.Count | Should -Be 10

            }

            It 'outputs object with expected typename' {

                $response | Get-Member | Select-Object -ExpandProperty typename -Unique | Should -Be IdCmd.Session

            }

        }

    }

}
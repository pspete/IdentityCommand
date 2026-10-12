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

        BeforeAll {
            $SessionStart = Get-Date '2026-01-01T09:00:00'
        }

        BeforeEach {

            #Stands in for a companion module session which has not yet been connected
            $ISPSSSession = [ordered]@{
                tenant_url = $null
                User       = $null
                StartTime  = $null
                WebSession = $null
            }
            New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
            New-Variable -Name ServiceKey -Value 'sca' -Scope Script -Force

            Mock Get-IDSession -MockWith {
                [ordered]@{
                    tenant_url = 'https://sometenant.id.cyberark.cloud'
                    User       = 'SomeUser'
                    Subdomain  = 'sometenant'
                    StartTime  = $SessionStart
                    WebSession = 'SomeWebSession'
                }
            }

            Mock Resolve-ServiceUrl -MockWith {
                [pscustomobject]@{
                    ServiceUrl  = "https://$Subdomain.$Service.cyberark.cloud"
                    IdentityUrl = "https://$Subdomain.id.cyberark.cloud"
                    ServicePath = ''
                }
            }

        }

        AfterAll {
            Remove-Variable -Name ServiceKey -Scope Script -ErrorAction SilentlyContinue
        }

        Context 'No IdentityCommand session' {

            It 'throws when there is no IdentityCommand session' {
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                { Resolve-RequestUrl -Path 'api/policies' } | Should -Throw 'Authenticate with New-IDSession*'
            }

            It 'uses a module session connected without an IdentityCommand session' {
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                $Script:ISPSSSession.tenant_url = 'https://explicit.example.com'
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://explicit.example.com/api'
            }

            It 'throws when the IdentityCommand session it was copied from has been closed' {
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                $Script:ISPSSSession.tenant_url = 'https://sometenant.sca.cyberark.cloud'
                $Script:ISPSSSession.StartTime = $SessionStart
                { Resolve-RequestUrl -Path 'api' } | Should -Throw 'Authenticate with New-IDSession*'
            }

            It 'clears the copied session values when the IdentityCommand session has been closed' {
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                $Script:ISPSSSession.tenant_url = 'https://sometenant.sca.cyberark.cloud'
                $Script:ISPSSSession.User = 'SomeUser'
                $Script:ISPSSSession.WebSession = 'SomeWebSession'
                $Script:ISPSSSession.StartTime = $SessionStart
                { Resolve-RequestUrl -Path 'api' } | Should -Throw
                $Script:ISPSSSession.tenant_url | Should -BeNullOrEmpty
                $Script:ISPSSSession.User | Should -BeNullOrEmpty
                $Script:ISPSSSession.WebSession | Should -BeNullOrEmpty
            }

        }

        Context 'Lazy connection' {

            It 'resolves the service URL by the session subdomain' {
                $null = Resolve-RequestUrl -Path 'api/policies'
                Should -Invoke Resolve-ServiceUrl -ParameterFilter {
                    $Service -eq 'sca' -and $Subdomain -eq 'sometenant'
                } -Times 1 -Exactly -Scope It
            }

            It 'returns the request URL' {
                Resolve-RequestUrl -Path 'api/policies' | Should -Be 'https://sometenant.sca.cyberark.cloud/api/policies'
            }

            It 'accepts a path with a leading slash' {
                Resolve-RequestUrl -Path '/api/policies' | Should -Be 'https://sometenant.sca.cyberark.cloud/api/policies'
            }

            It 'returns the service URL when no path is given' {
                Resolve-RequestUrl | Should -Be 'https://sometenant.sca.cyberark.cloud'
            }

            It 'resolves the service named by -Service' {
                Resolve-RequestUrl -Path 'api' -Service jit | Should -Be 'https://sometenant.jit.cyberark.cloud/api'
            }

            It 'copies the IdentityCommand session into the module session' {
                $null = Resolve-RequestUrl -Path 'api/policies'
                $Script:ISPSSSession.User | Should -Be 'SomeUser'
                $Script:ISPSSSession.WebSession | Should -Be 'SomeWebSession'
                $Script:ISPSSSession.StartTime | Should -Be $SessionStart
            }

            It 'keeps the service URL for later requests' {
                $null = Resolve-RequestUrl -Path 'api/policies'
                $null = Resolve-RequestUrl -Path 'api/policies'
                Should -Invoke Resolve-ServiceUrl -Times 1 -Exactly -Scope It
            }

            It 'throws when the session has no subdomain' {
                Mock Get-IDSession -MockWith { [ordered]@{ StartTime = $SessionStart; Subdomain = $null } }
                { Resolve-RequestUrl -Path 'api/policies' } | Should -Throw '*shared services subdomain*'
            }

            It 'throws when no service is specified' {
                Remove-Variable -Name ServiceKey -Scope Script
                { Resolve-RequestUrl -Path 'api/policies' } | Should -Throw 'No service specified*'
            }

        }

        Context 'Session changes' {

            It 'uses a service URL already set for the current session' {
                $Script:ISPSSSession.tenant_url = 'https://explicit.example.com'
                $Script:ISPSSSession.StartTime = $SessionStart
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://explicit.example.com/api'
                Should -Invoke Resolve-ServiceUrl -Times 0 -Exactly -Scope It
            }

            It 'copies a new IdentityCommand session and keeps the service URL for the same subdomain' {
                $Script:ISPSSSession.tenant_url = 'https://explicit.example.com'
                $Script:ISPSSSession.Subdomain = 'sometenant'
                $Script:ISPSSSession.StartTime = $SessionStart.AddHours(-1)
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://explicit.example.com/api'
                $Script:ISPSSSession.StartTime | Should -Be $SessionStart
                $Script:ISPSSSession.WebSession | Should -Be 'SomeWebSession'
            }

            It 'resolves the service URL again when the subdomain changes' {
                $Script:ISPSSSession.tenant_url = 'https://othertenant.sca.cyberark.cloud'
                $Script:ISPSSSession.Subdomain = 'othertenant'
                $Script:ISPSSSession.StartTime = $SessionStart.AddHours(-1)
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://sometenant.sca.cyberark.cloud/api'
            }

        }

        Context 'Module hooks' {

            BeforeEach {
                New-Variable -Name HookCount -Value 0 -Scope Script -Force
            }

            AfterEach {
                Remove-Variable -Name ServiceEndpoint, SessionConnectedHook, IndependentSession, HookCount -Scope Script -ErrorAction SilentlyContinue
            }

            It 'resolves the api endpoint when the module declares none' {
                $null = Resolve-RequestUrl -Path 'api'
                Should -Invoke Resolve-ServiceUrl -ParameterFilter { $Endpoint -eq 'api' } -Times 1 -Exactly -Scope It
            }

            It 'resolves the endpoint declared by the module' {
                New-Variable -Name ServiceEndpoint -Value 'bootstrap' -Scope Script -Force
                $null = Resolve-RequestUrl -Path 'api'
                Should -Invoke Resolve-ServiceUrl -ParameterFilter { $Endpoint -eq 'bootstrap' } -Times 1 -Exactly -Scope It
            }

            It 'runs the connected hook when the module connects' {
                New-Variable -Name SessionConnectedHook -Value { $Script:HookCount++ } -Scope Script -Force
                $null = Resolve-RequestUrl -Path 'api'
                $Script:HookCount | Should -Be 1
            }

            It 'runs the connected hook after the service URL is resolved' {
                New-Variable -Name SessionConnectedHook -Value { $Script:HookUrl = $ISPSSSession.tenant_url } -Scope Script -Force
                $null = Resolve-RequestUrl -Path 'api'
                $Script:HookUrl | Should -Be 'https://sometenant.sca.cyberark.cloud'
            }

            It 'does not run the connected hook for later requests' {
                New-Variable -Name SessionConnectedHook -Value { $Script:HookCount++ } -Scope Script -Force
                $null = Resolve-RequestUrl -Path 'api'
                $null = Resolve-RequestUrl -Path 'api'
                $Script:HookCount | Should -Be 1
            }

            It 'runs the connected hook again when the IdentityCommand session changes' {
                New-Variable -Name SessionConnectedHook -Value { $Script:HookCount++ } -Scope Script -Force
                $Script:ISPSSSession.tenant_url = 'https://sometenant.sca.cyberark.cloud'
                $Script:ISPSSSession.Subdomain = 'sometenant'
                $Script:ISPSSSession.StartTime = $SessionStart.AddHours(-1)
                $null = Resolve-RequestUrl -Path 'api'
                $Script:HookCount | Should -Be 1
                Should -Invoke Resolve-ServiceUrl -Times 0 -Exactly -Scope It
            }

            It 'throws when the connected hook fails' {
                New-Variable -Name SessionConnectedHook -Value { throw 'SomeHookError' } -Scope Script -Force
                { Resolve-RequestUrl -Path 'api' } | Should -Throw 'SomeHookError'
            }

            It 'runs the connected hook again on the next request after it fails' {
                New-Variable -Name SessionConnectedHook -Value { throw 'SomeHookError' } -Scope Script -Force
                { Resolve-RequestUrl -Path 'api' } | Should -Throw
                New-Variable -Name SessionConnectedHook -Value { $Script:HookCount++ } -Scope Script -Force
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://sometenant.sca.cyberark.cloud/api'
                $Script:HookCount | Should -Be 1
            }

            It 'throws when the IdentityCommand session is closed after the connected hook fails' {
                New-Variable -Name SessionConnectedHook -Value { throw 'SomeHookError' } -Scope Script -Force
                { Resolve-RequestUrl -Path 'api' } | Should -Throw 'SomeHookError'
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                { Resolve-RequestUrl -Path 'api' } | Should -Throw 'Authenticate with New-IDSession*'
                $Script:ISPSSSession.WebSession | Should -BeNullOrEmpty
            }

            It 'does not copy the IdentityCommand session into an independent session' {
                New-Variable -Name IndependentSession -Value $true -Scope Script -Force
                $Script:ISPSSSession.tenant_url = 'https://independent.example.com'
                $Script:ISPSSSession.WebSession = 'IndependentWebSession'
                $Script:ISPSSSession.StartTime = $SessionStart.AddHours(-1)
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://independent.example.com/api'
                $Script:ISPSSSession.WebSession | Should -Be 'IndependentWebSession'
                $Script:ISPSSSession.StartTime | Should -Be $SessionStart.AddHours(-1)
            }

            It 'does not clear an independent session when there is no IdentityCommand session' {
                Mock Get-IDSession -MockWith { [ordered]@{ tenant_url = $null; StartTime = $null } }
                New-Variable -Name IndependentSession -Value $true -Scope Script -Force
                $Script:ISPSSSession.tenant_url = 'https://independent.example.com'
                $Script:ISPSSSession.StartTime = $SessionStart
                Resolve-RequestUrl -Path 'api' | Should -Be 'https://independent.example.com/api'
            }

            It 'does not run the connected hook for an independent session' {
                New-Variable -Name IndependentSession -Value $true -Scope Script -Force
                New-Variable -Name SessionConnectedHook -Value { $Script:HookCount++ } -Scope Script -Force
                $Script:ISPSSSession.tenant_url = 'https://independent.example.com'
                $null = Resolve-RequestUrl -Path 'api'
                $Script:HookCount | Should -Be 0
            }

        }

    }

}

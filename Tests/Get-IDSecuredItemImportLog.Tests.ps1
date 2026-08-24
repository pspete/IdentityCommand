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

            $response = Get-IDSecuredItemImportLog -FileKey 'somefilekey'

        }

        Context 'Input' {

            It 'sends request' {

                Assert-MockCalled Invoke-IDRestMethod -Times 1 -Exactly -Scope It

            }

            It 'sends request to expected endpoint' {

                Assert-MockCalled Invoke-IDRestMethod -ParameterFilter {

                    $URI -eq 'https://somedomain.id.cyberark.cloud/UPRest/DownloadImportAccountsLogFile?fileKey=somefilekey'

                } -Times 1 -Exactly -Scope It

            }

        }

        Context 'Output' {

            It 'provides output' {

                $response | Should -Not -BeNullOrEmpty

            }

        }

        Context 'CSV byte[] response' {

            BeforeEach {

                $Csv = "idx,name,url,username,ImportedType,Status,StatusDescription,SharedPermissions`r`n1,exampleApp,https://www.examplewebsite.com,exampleuser,App,Success,,[]`r`n"
                $Bom = [Byte[]](0xEF, 0xBB, 0xBF)
                $Bytes = [Byte[]]($Bom + [System.Text.Encoding]::UTF8.GetBytes($Csv))

                Mock Invoke-IDRestMethod -MockWith { , $Bytes }

                $response = Get-IDSecuredItemImportLog -FileKey 'somefilekey'

            }

            It 'parses the CSV into objects' {

                $response.Count | Should -Be 1
                $response[0].name | Should -Be 'exampleApp'
                $response[0].Status | Should -Be 'Success'

            }

        }

        Context 'CSV response unrolled to untyped Object[]' {

            BeforeEach {

                #Confirmed live: crossing the Invoke-IDRestMethod/Get-IDResponse function boundary
                #unrolls a real Byte[] response into individual bytes, which get recollected here
                #as untyped Object[] rather than Byte[] - not the clean Byte[] case above
                $Csv = "idx,name`r`n1,exampleApp`r`n"
                $Bom = [Byte[]](0xEF, 0xBB, 0xBF)
                $Bytes = [Byte[]]($Bom + [System.Text.Encoding]::UTF8.GetBytes($Csv))
                $UnrolledBytes = [Object[]]$Bytes

                Mock Invoke-IDRestMethod -MockWith { $UnrolledBytes }

                $response = Get-IDSecuredItemImportLog -FileKey 'somefilekey'

            }

            It 'still parses the CSV into objects' {

                $response.Count | Should -Be 1
                $response[0].name | Should -Be 'exampleApp'

            }

        }

    }

}

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



        Context 'Standard Operation' {
            BeforeEach {

                $Object = [PSCustomObject]@{
                    Image = 'ABC123'
                }

                Mock Get-Item -MockWith { }

                Mock Out-File -MockWith { }

            }

            It 'does not throw' {

                { $Object | Out-QRImage -Path 'C:\Temp' } | Should -Not -Throw

            }

            It 'throws on Out-File error' {
                Mock Out-File -MockWith { throw 'error' }
                { $Object | Out-QRImage } | Should -Throw
            }

        }

    }

}

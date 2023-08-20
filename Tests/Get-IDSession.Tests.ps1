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

            Mock -CommandName Get-Variable -MockWith {}
            Get-IDSession

        }

        Context 'General' {

            It 'gets expected variable' {

                Assert-MockCalled Get-Variable -ParameterFilter {

                    $Name -eq 'WebSession'

                } -Times 1 -Exactly -Scope It

            }

            It 'gets variable from expected scope' {

                Assert-MockCalled Get-Variable -ParameterFilter {

                    $Scope -eq 'Script'

                } -Times 1 -Exactly -Scope It

            }

            It 'gets variable value' {

                Assert-MockCalled Get-Variable -ParameterFilter {

                    $ValueOnly -eq $true

                } -Times 1 -Exactly -Scope It

            }

        }

    }

}
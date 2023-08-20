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

                [array]$Mechanisms = [pscustomobject]@{
                    PromptSelectMech = '1'
                    PromptMechChosen = 'Option1'
                },
                [pscustomobject]@{
                    PromptSelectMech = '2'
                    PromptMechChosen = 'Option2'
                },
                [pscustomobject]@{
                    PromptSelectMech = '3'
                    PromptMechChosen = 'Option3'
                }

            }

            It 'returns choice 1 when selected' {
                Mock Get-Host {
                    [pscustomobject] @{
                        ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 0 }
                    }
                }
                Select-ChallengeMechanism -Mechanisms $Mechanisms | Select-Object -ExpandProperty PromptMechChosen | Should -Be 'Option1'
            }

            It 'returns choice 2 when selected' {
                Mock Get-Host {
                    [pscustomobject] @{
                        ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 1 }
                    }
                }
                Select-ChallengeMechanism -Mechanisms $Mechanisms | Select-Object -ExpandProperty PromptMechChosen | Should -Be 'Option2'
            }

            It 'returns choice 3 when selected' {
                Mock Get-Host {
                    [pscustomobject] @{
                        ui = Add-Member -PassThru -Name PromptForChoice -InputObject ([pscustomobject] @{}) -Type ScriptMethod -Value { return 2 }
                    }
                }
                Select-ChallengeMechanism -Mechanisms $Mechanisms | Select-Object -ExpandProperty PromptMechChosen | Should -Be 'Option3'
            }

            It 'automatically selects choice when only single choice available' {
                [array]$Mechanisms = [pscustomobject]@{
                    PromptSelectMech = '1'
                    PromptMechChosen = 'Option1'
                }

                Select-ChallengeMechanism -Mechanisms $Mechanisms | Select-Object -ExpandProperty PromptMechChosen | Should -Be 'Option1'
            }

        }

    }

}

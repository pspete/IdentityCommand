using namespace System.Management.Automation.Host

function Select-ChallengeMechanism {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [array]$Mechanisms
    )

    Begin {

        $option = 0

    }

    Process {

        If ($Mechanisms.count -gt 1) {

            foreach ($Mechanism in $Mechanisms) {

                [ChoiceDescription[]]$options += [ChoiceDescription]::new("&$($Mechanism.PromptSelectMech)", $($Mechanism.PromptMechChosen))

            }

            $option = $host.ui.PromptForChoice('Challenge Mechanisms', 'Select Mechanism', $options, 0)


        }

        $Mechanisms[$option]

    }

    End { }

}

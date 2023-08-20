using namespace System.Management.Automation.Host

function Select-ChallengeMechanism {
    <#
    .SYNOPSIS
    Allows user selction of MFA challenge mechanism

    .DESCRIPTION
    Displays menu of available MFA mechanisms.
    Users are abe to select the mechanism they wish to satisfy to proceed with MFA challenge for authentication.

    .PARAMETER Mechanisms
    The array of mechanisms returned after the Start Authentication action.

    .EXAMPLE
    Select-ChallengeMechanism -Mechanisms $Mechanisms

    Creates a selection menu from $Mechanisms, and allows a user to select a single mechanism with which to proceed.

    .NOTES
    Pete Maan 2023
    #>

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

            $option = (Get-Host).ui.PromptForChoice('Challenge Mechanisms', 'Select Mechanism', $options, 0)


        }

        $Mechanisms[$option]

    }

    End { }

}

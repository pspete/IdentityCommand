function Get-MechanismAnswer {
    <#
    .SYNOPSIS
    Allows a user to answer an MFA chalenge Mechanism

    .DESCRIPTION
    MFA Challenges include User Password, Security Questions, SMS, OATH, Email, OTP, Phone Call & QR Code.
    Password is supplied automatically from provided credential object.
    Users are able to provide input to answer OATH, SMS or Security Questions.
    Out of Band factors (Phone Call, QR Code App Push & Email validation Link) are polled for until satisfied.
    U2F and DUO are not currenlty supported via this code.

    .PARAMETER Mechanism
    The mechanism to answer

    .PARAMETER Credential
    Credential obejct containing username & password for Identity tenant authentication

    .EXAMPLE
    $Answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Credential

    Prompts the user to answer the challenge mechanism and saves the response to the $answer variable for use to advance the authentication.

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
        [psobject]$Mechanism,

        #User Creds
        [Parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $false
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
    )

    Begin {}

    Process {

        switch ($Mechanism.Name) {

            'UP' {

                #User Password already provided via Credential
                $Answer = $Credential.Password

                break

            }

            'SQ' {

                #Create Key/Value pairs for each question Uuid/Answer
                $Answer = @{}

                foreach ($MechanismPart in $($Mechanism.MultipartMechanism.MechanismParts)) {

                    $Answer[$MechanismPart.Uuid] = Read-Host -Prompt $($MechanismPart.PromptMechChosen) -AsSecureString

                }

                break

            }

            { $PSItem -match 'EMAIL|OTP|PF|QR' } {

                #App Push, Email Validation link, QR or Phone + PIN
                #todo APP/EMAIL also support specify OTP as answer
                #todo user should be able to choose push or answer

                #Output instructions to console
                Write-Host $($Mechanism.PromptMechChosen)

                if ($PSItem -eq 'QR') {

                    Write-Host 'Displaying QR in Browser...'
                    $Mechanism | Out-QRImage | Invoke-Item

                }

                break

            }

            { $PSItem -match 'SMS|OATH' } {

                #Prompt for TOTP/SMS code input
                $Answer = Read-Host -Prompt $($Mechanism.PromptMechChosen) -AsSecureString
                break

            }

            'RESET' {

                #Expired Password: prompt for new value & confirmation
                $attempt = 0

                do {

                    If ($attempt -ge 1) {

                        Write-Warning 'Passwords did not match, please try again.'

                    }

                    Write-Host "$($Mechanism.PasswordComplexityHint)"

                    $Answer = Read-Host -Prompt 'Password' -AsSecureString
                    $Confirm = Read-Host -Prompt 'Confirm Password' -AsSecureString
                    $attempt++

                }
                while (-not(Compare-SecureString -SecureString1 $Answer -SecureString2 $Confirm))

                break

            }

            default {

                #Unsupported Mechanism [U2F|DUO]
                throw "Support for $PSItem mechanism not yet implemented in the module"
                break

            }

        }

    }

    End {
        $Answer
    }

}

function New-IDAuthenticationProfile {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
        [Parameter(Mandatory = $True)]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $FirstFactorChallenges,

        [Parameter(Mandatory = $false)]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $SecondFactorChallenges,

        [Parameter(Mandatory = $false)]
        $AdditionalData = @{},
        
        [Parameter(Mandatory = $false)]
        [ValidateSet("QR","PASSKEY")]
        $SingleChallengeMechanisms = "",

        [Parameter(Mandatory = $false)]
        [int]$DurationInMinutes = 30,

        [Parameter(Mandatory = $true)]
        $Name
    )

    BEGIN {      

        $SQ = ("SQ" -in $FirstFactorChallenges) -or ("SQ" -in $SecondFactorChallenges)

        [string]$FirstFactorChallenges  = $FirstFactorChallenges
        $FirstFactorChallenges  = $FirstFactorChallenges.Replace(" ",",")
        [string]$SecondFactorChallenges  = $SecondFactorChallenges
        $SecondFactorChallenges  = $SecondFactorChallenges.Replace(" ",",")

        if ($SQ -and ($null -eq $AdditionalData)) {

            Write-Warning "When Security Question is specified you have to specify the number of questions to be asked in AdditionalData"
            [int]$SQNumber = Read-Host "Number of questions to be asked:"
            $AdditionalData = @{

                "NumberOfQuestions" = $SQNumber
            }
        }

    } #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Create Authentication Profile')) {

            #constructed body
            $Body = @{

                "settings" = @{
                    "Name"                      = $Name
                    "Challenges"                = "$FirstFactorChallenges", "$SecondFactorChallenges"
                    "SingleChallengeMechanisms" = $SingleChallengeMechanisms
                    "DurationInMinutes"         = $DurationInMinutes
                    "AdditionalData"            = $AdditionalData
                }
            }

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/AuthProfile/SaveProfile"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ConvertTo-JSON -InputObject $Body #
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    }#process

    END {} #end
}

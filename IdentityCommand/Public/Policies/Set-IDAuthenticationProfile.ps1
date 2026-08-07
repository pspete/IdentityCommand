function Set-IDAuthenticationProfile {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        $Uuid,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true,
        ParameterSetName = "NotFilled")]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $FirstFactorChallenges,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true,
        ParameterSetName = "NotFilled")]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $SecondFactorChallenges,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        $AdditionalData = @{},
        
        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        [ValidateSet("","QR","PASSKEY")]
        $SingleChallengeMechanisms,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        [int]$DurationInMinutes = 30,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        $Name,

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true,
        ParameterSetName = "Prefilled")]
        $Challenges = ""
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

        if ("" -eq $Challenges) {

            $Challenges = "$FirstFactorChallenges", "$SecondFactorChallenges"

        }
    } #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Uuid, 'Update Authentication Profile')) {

            #constructed body
            $Body = @{

                "settings" = @{
                    "Name"                      = $Name
                    "Challenges"                = $Challenges
                    "SingleChallengeMechanisms" = $SingleChallengeMechanisms
                    "Uuid"                      = $Uuid
                    "DurationInMinutes"         = $DurationInMinutes
                    "AdditionalData"            = $AdditionalData
                }
            }
            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/AuthProfile/SaveProfile"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ($Body | ConvertTo-Json)
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    }#process

    END {} #end
}

function Get-IDAuthenticationAssuranceLevel {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true,
        ParameterSetName = "NotFilled")]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $FirstFactorChallenges,

        [Parameter(Mandatory = $false,
        ParameterSetName = "NotFilled")]
        [ValidateSet("OTP","PF","OATH","SMS","EMAIL","QR","U2F","U2FONDEVICE","PASSKEY","UP","SQ","RADIUS")]
        $SecondFactorChallenges,

        [Parameter(Mandatory = $true,
        ParameterSetName = "Prefilled",
        ValueFromPipelinebyPropertyName = $true)]
        $Challenges = ""
    )

    BEGIN {      

        [string]$FirstFactorChallenges  = $FirstFactorChallenges
        $FirstFactorChallenges  = $FirstFactorChallenges.Replace(" ",",")
        [string]$SecondFactorChallenges  = $SecondFactorChallenges
        $SecondFactorChallenges  = $SecondFactorChallenges.Replace(" ",",")

        if ("" -eq $Challenges) {

            $Challenges = "$FirstFactorChallenges", "$SecondFactorChallenges"

        }

    } #begin

    PROCESS {

        #constructed body
        $Body = @{

            "Challenges" = $Challenges

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/AuthProfile/GetProfileMFAScoring"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($Body | ConvertTo-Json)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result
    }#process

    END {} #end
}

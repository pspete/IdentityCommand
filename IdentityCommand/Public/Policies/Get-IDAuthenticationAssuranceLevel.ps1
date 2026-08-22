# .ExternalHelp IdentityCommand-help.xml
function Get-IDAuthenticationAssuranceLevel {

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('OTP', 'PF', 'OATH', 'SMS', 'EMAIL', 'QR', 'U2F', 'U2FONDEVICE', 'PASSKEY', 'UP', 'SQ', 'RADIUS')]
        $FirstFactorChallenges,

        [Parameter(Mandatory = $false)]
        [ValidateSet('OTP', 'PF', 'OATH', 'SMS', 'EMAIL', 'QR', 'U2F', 'U2FONDEVICE', 'PASSKEY', 'UP', 'SQ', 'RADIUS')]
        $SecondFactorChallenges
    )

    begin {

        [string]$FirstFactorChallenges = $FirstFactorChallenges
        $FirstFactorChallenges = $FirstFactorChallenges.Replace(' ', ',')
        [string]$SecondFactorChallenges = $SecondFactorChallenges
        $SecondFactorChallenges = $SecondFactorChallenges.Replace(' ', ',')

        $Challenges = "$FirstFactorChallenges", "$SecondFactorChallenges"

    } #begin

    process {

        #constructed body
        $Body = @{

            'Challenges' = $Challenges

        }

        #Constructed parameters for the rest call
        $RestCall = @{

            'URI'         = "$($ISPSSSession.tenant_url)/AuthProfile/GetProfileMFAScoring"
            'Headers'     = $($ISPSSSession.WebSession.Headers)
            'Method'      = 'Post'
            'Body'        = ($Body | ConvertTo-Json)
            'ContentType' = 'application/json'

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result
    }#process

    end {} #end
}

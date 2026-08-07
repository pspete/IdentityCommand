# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDUserU2FRegistrationChallenge {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [String]$AuthenticatorType,

        [parameter(Mandatory = $false)]
        [String]$UserDefinedName
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/U2f/GetRegistrationChallenge"

        $Query = @{}

        if ($PSBoundParameters.ContainsKey('AuthenticatorType')) { $Query['authenticatorType'] = $AuthenticatorType }
        if ($PSBoundParameters.ContainsKey('UserDefinedName')) { $Query['userDefinedName'] = $UserDefinedName }

        if ($Query.Count -gt 0) {

            $URI = "$URI`?$($Query | ConvertTo-QueryString)"

        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21. U2f/GetRegistrationChallenge always fails with
# "Unexpected null arguments passed to the server." / "Parameter host may not be null or
# whitespace" regardless of -AuthenticatorType/-UserDefinedName being supplied. Three attempts to
# supply the missing 'host' value all failed identically: as a query-string param alongside the
# others, as a JSON body field, and as both together. The server may be deriving 'host' from an
# HTTP header or request context this command doesn't currently set (e.g. Referer, or a
# WebAuthn/U2F-specific origin header), rather than accepting it as a normal parameter at all. Not
# being pursued further by guessing; next step if revisited is a DevTools capture of the actual
# U2F/security-key registration flow in the end-user or admin portal.
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

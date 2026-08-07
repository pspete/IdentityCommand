# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This starts a redirect-based external IdP (social login) flow. No sample response body was
# available to confirm what's returned (e.g. an authorize URL to open in a browser) or how/whether
# the flow can be completed programmatically after the external IdP redirects back to
# -CallbackUrl. This command only performs the 'start' call and returns the raw response for the
# caller to inspect and act on - there is no accompanying 'Complete-' command.
function Start-IDSocialAuthentication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$IdpName,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$CallbackUrl
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($IdpName, 'Start Social Authentication')) {

            $Body = [ordered]@{
                'IdpName'                   = $IdpName
                'PostExtIdpAuthCallbackUrl' = $CallbackUrl
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Security/StartSocialAuthentication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

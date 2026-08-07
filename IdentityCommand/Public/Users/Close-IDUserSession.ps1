# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: It's unconfirmed whether this is functionally distinct from Close-IDSession (which wraps
# /Security/Logout) or a near-duplicate of it via a different API namespace. Verify against a live
# tenant whether the two behave differently (e.g. scope of what gets signed out) before assuming
# either is redundant.
function Close-IDUserSession {
    [CmdletBinding(SupportsShouldProcess)]
    param()

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Sign Out Current Session')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/SignOutCurrentSession"
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

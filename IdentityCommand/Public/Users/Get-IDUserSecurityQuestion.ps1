# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: No sample request was found for this endpoint anywhere checked (Bruno collection or swagger
# schema beyond its existence and one-line summary). The no-body shape used here is inferred by
# analogy with the admin-level equivalent, Get-IDTenantSecurityQuestion (TenantConfig/
# GetAdminSecurityQuestions), which is a distinct, already-confirmed endpoint - this one instead
# wraps UserMgmt/GetSecurityQuestions, presumably scoped to the current/a specific user rather than
# tenant-wide admin questions.
function Get-IDUserSecurityQuestion {
    [CmdletBinding()]
    param()

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/GetSecurityQuestions"
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# TODO: Returns the tenant-wide security question policy (AnswerMinLength/MaxQuestions/
# MinAdminQuestions/MinUserQuestions/Questions), not a specific user's answered questions. Despite
# its "User" naming, UserMgmt/GetSecurityQuestions takes no per-user scoping - it reflects the
# policy applied to the current session's tenant.
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

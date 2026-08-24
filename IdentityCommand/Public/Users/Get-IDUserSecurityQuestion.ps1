# .ExternalHelp IdentityCommand-help.xml
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

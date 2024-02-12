# .ExternalHelp IdentityCommand-help.xml
function Close-IDSession {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$($ISPSSSession.tenant_url)/Security/Logout"

    }#begin

    PROCESS {

        #Send Logoff Request
        Invoke-IDRestMethod -Uri $URI -Method POST | Out-Null

    }#process

    END {

        #Remove Module scope variables on logoff
        $ISPSSSession.tenant_url = $null
        $ISPSSSession.TenantId = $null
        $ISPSSSession.WebSession = $null
        $ISPSSSession.User = $null
        $ISPSSSession.StartTime = $null
        $ISPSSSession.SessionId = $null

    }#end

}
# .ExternalHelp IdentityCommand-help.xml
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
            Invoke-IDRestMethod @Request | Out-Null

            #Confirmed live: unlike Close-IDSession, this endpoint doesn't clear local session
            #state on its own - do it here so a dead server-side session doesn't linger locally
            $ISPSSSession.tenant_url = $null
            $ISPSSSession.TenantId = $null
            $ISPSSSession.WebSession = $null
            $ISPSSSession.User = $null
            $ISPSSSession.StartTime = $null
            $ISPSSSession.SessionId = $null

        }

    }#process

    END {}#end

}

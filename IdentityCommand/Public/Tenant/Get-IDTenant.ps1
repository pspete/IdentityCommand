# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenant {

    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/SysInfo/About"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

        }

        #Send Request
        $result = Invoke-IDRestMethod @RestCall

        return $result

    }#process

    END {}#end

}
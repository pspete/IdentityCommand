# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantConfiguration {
    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/TenantConfig/GetCustomerConfig"
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
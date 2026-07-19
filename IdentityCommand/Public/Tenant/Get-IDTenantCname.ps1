# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantCname {
    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/TenantCnames/UiGet"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

        }
        #Send Request
        $result = Invoke-IDRestMethod @RestCall

        return $result.Results.Row

    }#process

    END {}#end

}
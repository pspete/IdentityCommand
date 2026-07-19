# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantSuffix {
    
    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Core/GetAliasesForTenant"
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
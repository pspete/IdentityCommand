function Get-IDPermission {

    [CmdletBinding()]
	param
	(
       
    )

    BEGIN {
        # Query to get all available permissions
        $Query = @{
            "Script"="@/lib/get_superrights.js(excludeRight:'')"
            "Args" = @{ "PageNumber"=1
                    "PageSize"="10000"
                    "Limit"="10000"
                    "SortBy"=""
                    "direction"="False"
                    "Caching"="-1"}
        }

    } #begin

    PROCESS {

        #Constructed parameters for the rest call
        $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/redrock/query/"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ($Query | ConvertTo-Json)
            "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result.Results.Row

    } #process

    END {}#end

}

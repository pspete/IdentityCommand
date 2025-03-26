function Get-IDPermission {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$tenantID

    )

    $Query = @{
	    "Script"="@/lib/get_superrights.js(excludeRight:'')"
	    "Args" = @{ "PageNumber"=1
                "PageSize"="10000"
                "Limit"="10000"
                "SortBy"=""
                "direction"="False"
                "Caching"="-1"}
    }


    $RestCall = @{

        "URI"         = "https://$tenantID.id.cyberark.cloud/redrock/query/"
        "Headers"     = $ISPSSSession:WebSession
        "Method"      = "Post"
        "Body"        = ($Query | ConvertTo-Json)
        "ContentType" = "application/json"

    }

    $result = Invoke-RestMethod @RestCall

    return $result.Result.Results.Row

}

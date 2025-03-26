function Get-IDRole {

    [CmdletBinding(DefaultParameterSetName = 'Redrock')]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$tenantID,

        [Parameter(Mandatory = $false, 
        ParameterSetName = 'Redrock')]
		$Query = @{"Script" = "Select * from Role ORDER BY Name COLLATE NOCASE"},

        [Parameter(Mandatory = $true, ParameterSetName = 'API')]
		$UUID,

        [Parameter(Mandatory = $false, ParameterSetName = 'API')]
        [switch]$API
	)
    
    if (!$API) {

        $RestCall = @{

            "URI"         = "https://$tenantID.id.cyberark.cloud/redrock/query/"
            "Headers"     = $ISPSSSession:WebSession
            "Method"      = "Post"
            "Body"        = ($Query | ConvertTo-Json)
            "ContentType" = "application/json"

        }

        $result = Invoke-RestMethod @RestCall

        return $result.Result.Results.row

    }

        if ($API) {

        $RestCall = @{

            "URI"         = "https://$tenantID.id.cyberark.cloud/Roles/GetRole?Name=$UUID"
            "Headers"     = $Script:WebSession
            "Method"      = "Post"
            "ContentType" = "application/json"

        }
    
        $result = Invoke-RestMethod @RestCall

        return $result.Result

    } 
}

$PVWAURL = "https://abf4386.id.cyberark.cloud/oauth2/platformtoken"

$body = @{

    "grant_type"    = "client_credentials"
    "client_id"     = "api-user@slaskeh.com"
    "client_secret" = "oc3C/;7Z"

}

$token = Invoke-RestMethod -Uri "$PVWAURL" -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"  -Verbose

$Query = @{

    "Script" = "Select * from Role
    WHERE Name = 'System Administrator'
    ORDER BY Name COLLATE NOCASE"

}

$storedProcedure = @{

    "Script" = "@/lib/all_roles_with_members.js"

}

$permissions = @{
	"Script"="@/lib/get_superrights.js(excludeRight:'')"
	"Args" = @{ "PageNumber"=1
                "PageSize"="10000"
                "Limit"="10000"
                "SortBy"=""
                "direction"="False"
                "Caching"="-1"}
}

Get-IDRole -tenantID "abf4386" -token $token -Query $permissions

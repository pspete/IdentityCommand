function Get-IDRolePermission {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
        [Alias('Uuid')]
        $Name

    )

    BEGIN {

        $body = @{

            "Role" = $Name
            "Args" = @{
                "PageNumber" = "1"
                "PageSize"   = "100000"
                "Limit"      = "100000"
                "SortBy"     = ""
                "Caching"    = "-1"
            } 
        }

    } #begin

    PROCESS {

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Core/GetAssignedAdministrativeRights?$Name"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-RestMethod @RestCall

        return $result.Result.results.row

    } #process

    END {} #end
}

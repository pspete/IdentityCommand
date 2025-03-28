function Get-IDRoleMember {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
        [Alias('Uuid')]
        $Name

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "Name"        = $Name

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/GetRoleMembers"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-RestMethod @RestCall

        return $result.Result.results.row

    } #process

    END {} #end
}

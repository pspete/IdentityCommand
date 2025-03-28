function Set-IDDynamicRoleScript {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
        [Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "ID"   = $Name
            "Script" = $Script

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/SetDynamicRoleScript"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-RestMethod @RestCall

        return $result

    } #process

    END {} #end
}

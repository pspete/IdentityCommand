function Remove-IDRole {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $false)]
        [array]$Roles = @()

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = (

            $Roles

        )

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/SaasManage/DeleteRoles"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = (ConvertTo-JSON -InputObject $body) 
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-RestMethod @RestCall

        return $result

    } #process

    END {} #end

}


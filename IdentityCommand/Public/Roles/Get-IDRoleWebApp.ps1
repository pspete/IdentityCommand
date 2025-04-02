function Get-IDRoleWebApp {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/SaasManage/GetRoleApps?role=$Name"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = $body
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result.results.row

    } #process

    END {} #end
}

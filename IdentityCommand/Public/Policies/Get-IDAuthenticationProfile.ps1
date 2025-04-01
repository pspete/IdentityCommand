function Get-IDAuthenticationProfile {

    [CmdletBinding()]
	param
	(
    
    )

    BEGIN {} #begin

    PROCESS {

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/AuthProfile/GetDecoratedProfileList"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result.results.row

    } #process

    END {} #end
}

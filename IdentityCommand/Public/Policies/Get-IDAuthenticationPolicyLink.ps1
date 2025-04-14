function Get-IDAuthenticationPolicyLink {

    [CmdletBinding()]
	param
	(

    )

    BEGIN {} #begin

    PROCESS {

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Policy/GetNicePlinks"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result.Results.Row
        } #process

    END {} #end
}

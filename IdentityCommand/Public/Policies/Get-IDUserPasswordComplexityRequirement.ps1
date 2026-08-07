function Get-IDUserPasswordComplexityRequirement {

    [CmdletBinding()]
	param
	(

    )

    BEGIN {} #begin

    PROCESS {

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Policy/GetPasswordComplexityRequirements"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result
        } #process

    END {} #end
}

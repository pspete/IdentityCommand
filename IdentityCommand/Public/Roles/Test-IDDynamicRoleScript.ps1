function Test-IDDynamicRoleScript {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true)]
        $User,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call - built via ConvertTo-Json (not raw string
        #interpolation) so script content containing quotes/newlines is escaped correctly.
        $body = ([ordered]@{
            'User'   = $User
            'Script' = $Script
        } | ConvertTo-Json)

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/Roles/TestDynamicRoleScript"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = $body
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}

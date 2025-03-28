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

        #Constructed body for the rest call
        $body = [ordered]@{

            "User"   = $User
            "Script" = $Script

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/TestDynamicRoleScript"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-RestMethod @RestCall

        # Returns a false results as powershell adds escaping characters
        # to the script string, making it not a proper javascript script
        Write-Warning "This will return a false result due to how Powershell adds escaping characters"
        return $result.Result

    } #process

    END {} #end
}

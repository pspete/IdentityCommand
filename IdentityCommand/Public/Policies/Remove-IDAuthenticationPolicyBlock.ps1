# Unsure what the name parameter is asking for

function Remove-IDAuthenticationPolicyBlock {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('PolicySet')]
        $Name  
    )

    BEGIN { } #begin

    PROCESS {

        if ($Name -notlike "/Policy/*") {

            Write-Warning "The name parameter must be in the syntax the '/Policy/<PolicyName>'"
            break
        }

        $Body = @{

            "path" = $Name

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Policy/DeletePolicyBlock"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($Body | ConvertTo-Json)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}

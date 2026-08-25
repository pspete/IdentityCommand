# .ExternalHelp IdentityCommand-help.xml
function Get-IDAuthenticationPolicyBlock {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('PolicySet', 'ID')]
        $Name
    )

    BEGIN { } #begin

    PROCESS {

        $Body = @{

            "Name" = $Name

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/Policy/GetPolicyBlock"
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

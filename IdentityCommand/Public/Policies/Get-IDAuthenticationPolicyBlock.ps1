# Verified against a live tenant. -Name is the name of the authentication policy/policy set
# itself (e.g. as shown in the CyberArk Identity Admin Portal's Authentication -> Policies page),
# not a role name. Matches the 'ID' property on Get-IDAuthenticationPolicyLink output directly,
# hence the -ID alias below for direct pipeline binding from that command.
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

# Confirmed live 2026-08-21: requires the role's actual ID/UUID/_RowKey, not its display name -
# renamed the parameter from -Name to -ID to reflect this (it was previously named -Name with -ID
# only as an alias, which misled callers into passing a display name that doesn't work).
function Get-IDRoleMember {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "Name"        = $ID

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/Roles/GetRoleMembers"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result.results.row

    } #process

    END {} #end
}

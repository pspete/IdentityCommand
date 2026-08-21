# Confirmed live 2026-08-21: requires the role's actual ID/UUID/_RowKey, not its display name -
# added -ID as an explicit alias for discoverability (it was already aliased -Uuid).
function Add-IDRoleMember {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid', 'ID')]
        $Name,

        [Parameter(Mandatory = $false)]
        [array]$Users = @(),

        [Parameter(Mandatory = $false)]
        [array]$Roles = @(),

        [Parameter(Mandatory = $false)]
        [array]$Groups = @()

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "Name"        = $Name
            "Users"       = $Users
            "Roles"       = $Roles
            "Groups"      = $Groups

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/SaasManage/AddUsersAndGroupsToRole"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 6)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}

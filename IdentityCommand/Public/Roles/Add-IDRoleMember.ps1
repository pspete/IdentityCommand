# Confirmed live 2026-08-21: requires the role's actual ID/UUID/_RowKey, not its display name -
# renamed the parameter from -Name to -ID to reflect this (it was previously named -Name with -ID
# only as an alias, which misled callers into passing a display name that doesn't work).
function Add-IDRoleMember {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID,

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

            "Name"        = $ID
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

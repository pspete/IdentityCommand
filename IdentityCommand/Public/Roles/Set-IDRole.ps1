# Confirmed live 2026-08-21: requires the role's actual ID/UUID/_RowKey, not its display name -
# renamed the parameter from -Name to -ID to reflect this (it was previously named -Name with -ID
# only as an alias, which misled callers into passing a display name that doesn't work).
function Set-IDRole {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID,

        [Parameter(Mandatory = $false)]
        [array]$AddUsers = @(),

        [Parameter(Mandatory = $false)]
        [array]$RemoveUsers = @(),

        [Parameter(Mandatory = $false)]
        [array]$AddRoles = @(),

        [Parameter(Mandatory = $false)]
        [array]$RemoveRoles = @(),

        [Parameter(Mandatory = $false)]
        [array]$AddGroups = @(),

        [Parameter(Mandatory = $false)]
        [array]$RemoveGroups = @()

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Update Role')) {

            # contructed list of users, roles or groups to add or delete
            $UsersUpdate = @{

                "Delete" = $RemoveUsers
                "Add"    = $AddUsers

            }

            $RolesUpdate = @{

                "Delete" = $RemoveRoles
                "Add"    = $AddRoles

            }

            $GroupsUpdate = @{

                "Delete" = $RemoveGroups
                "Add"    = $AddGroups

            }

            #Constructed body for the rest call
            $body = [ordered]@{

                "Name"        = $ID
                "Users"       = $UsersUpdate
                "Roles"       = $RolesUpdate
                "Groups"      = $GroupsUpdate

            }

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Roles/UpdateRole/"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ($body | ConvertTo-Json -Depth 6)
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end
}

function Set-IDRole {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name,

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

        if ($PSCmdlet.ShouldProcess($Name, 'Update Role')) {

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

                "Name"        = $UUID
                "Users"       = $UsersUpdate
                "Roles"       = $RolesUpdate
                "Groups"      = $GroupsUpdate

            }

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/UpdateRole/"
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

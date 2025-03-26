function Update-IDRole {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$tenantID,

        [Parameter(Mandatory = $true)]
        $UUID,

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

    $body = [ordered]@{

        "Name"        = $UUID
        "Users"       = $UsersUpdate
        "Roles"       = $RolesUpdate
        "Groups"      = $GroupsUpdate

    }

    $RestCall = @{

    "URI"         = "https://$tenantID.id.cyberark.cloud/Roles/UpdateRole/"
    "Headers"     = $ISPSSSession:WebSession
    "Method"      = "Post"
    "Body"        = ($body | ConvertTo-Json -Depth 6)
    "ContentType" = "application/json"

    }

    $result = Invoke-RestMethod @RestCall

    return $result
}

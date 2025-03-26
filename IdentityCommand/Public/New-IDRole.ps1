function New-IDRole {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$tenantID,

        [Parameter(Mandatory = $true)]
        $Name,

        [Parameter(Mandatory = $false)]
        $Description = "",

        [Parameter(Mandatory = $false)]
        [array]$Users = @(),

        [Parameter(Mandatory = $false)]
        [array]$Roles = @(),

        [Parameter(Mandatory = $false)]
        [array]$Groups = @(),

        [Parameter(Mandatory = $false)]
        [ValidateSet('PrincipalList', 'Script', 'Everybody')]
        $RoleType = @(),

        [Parameter(Mandatory = $false)]
        $OrgPath = ""

    )

    $body = [ordered]@{

        "Name"        = $Name
        "Description" = $Description
        "Users"       = $Users
        "Roles"       = $Roles
        "Groups"      = $Groups
        "RoleType"    = $RoleType
        "OrgPath"     = $OrgPath


    }

    $RestCall = @{

    "URI"         = "https://$tenantID.id.cyberark.cloud/Roles/StoreRole/"
    "Headers"     = $ISPSSSession:WebSession
    "Method"      = "Post"
    "Body"        = ($body | ConvertTo-Json -Depth 3)
    "ContentType" = "application/json"

    }

    $result = Invoke-RestMethod @RestCall

    return $result
}


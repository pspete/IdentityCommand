function New-IDRole {

    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
        [Alias('Uuid')]
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
        $RoleType = 'PrincipalList',

        [Parameter(Mandatory = $false)]
        $OrgPath = ""

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed body for the rest call
        $body = [ordered]@{

            "Name"        = $Name
            "Description" = $Description
            "Users"       = $Users
            "Roles"       = $Roles
            "Groups"      = $Groups
            "RoleType"    = $RoleType
            "OrgPath"     = $OrgPath

        }

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/StoreRole/"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = ($body | ConvertTo-Json -Depth 3)
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end

}


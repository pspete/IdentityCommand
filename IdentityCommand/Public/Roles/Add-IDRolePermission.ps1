# Confirmed live 2026-08-21: requires the role's actual ID/UUID/_RowKey, not its display name -
# despite this endpoint's "Role" body key (shared with Get-IDRolePermission, which genuinely does
# accept the display name via a different underlying endpoint, Core/GetAssignedAdministrativeRights
# - this one hits Roles/AssignSuperRights instead). Renamed the parameter from -Name to -ID to
# reflect this (it was previously named -Name with -ID only as an alias, which misled callers into
# passing a display name that doesn't work).
function Add-IDRolePermission {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID,

        [Parameter(Mandatory = $true)]
        [string]$Path

    )

    BEGIN {

        $currentAvailablePermissions = Get-IDPermission

        if ($Path -notin $currentAvailablePermissions.Path) {

            Write-Warning "$Path is not a valid permission. Run Get-IDPermission to list all available permissions"
            break 

        }

    } #begin

    PROCESS {

        #Constructed body for the rest call
        $body = @(
            @{

            "Role"        = $ID
            "Path"        = $Path

            }
        )

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/Roles/AssignSuperRights"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = (ConvertTo-JSON -InputObject $body) 
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result

    } #process

    END {} #end
}

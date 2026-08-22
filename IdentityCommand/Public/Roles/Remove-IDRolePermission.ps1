# Confirmed live 2026-08-22: requires the role's actual ID/UUID/_RowKey, not its display name,
# matching the confirmed-live behavior of the sibling Add-IDRolePermission (same "Role" body key,
# same Roles/*SuperRights endpoint family). Verified end-to-end against a permission genuinely
# granted first via Add-IDRolePermission -ID, then removed via this command. Renamed the parameter
# from -Name to -ID to reflect this (it was previously named -Name with -ID only as an alias,
# which misled callers into passing a display name that doesn't work).
function Remove-IDRolePermission {

    [CmdletBinding(SupportsShouldProcess)]
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

        if ($PSCmdlet.ShouldProcess($ID, "Remove Role Permission '$Path'")) {

            #Constructed body for the rest call
            $body = @(
                @{

                "Role"        = $ID
                "Path"        = $Path

                }
            )

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Roles/UnAssignSuperRights"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = (ConvertTo-JSON -InputObject $body)
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end
}

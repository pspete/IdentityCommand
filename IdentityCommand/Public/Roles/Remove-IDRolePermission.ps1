# Very likely requires the role's actual ID/UUID/_RowKey, not its display name, matching the
# confirmed-live behavior of the sibling Add-IDRolePermission (same "Role" body key, same
# Roles/*SuperRights endpoint family). An earlier live test that appeared to succeed with the
# display name is not trusted as real confirmation - removing a permission that was never actually
# granted (because the matching Add-IDRolePermission call had itself failed) can plausibly return
# success as a no-op regardless of whether the role reference was valid. Added -ID as an explicit
# alias for discoverability (it was already aliased -Uuid); needs live re-verification with -ID.
function Remove-IDRolePermission {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid', 'ID')]
        $Name,

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

        if ($PSCmdlet.ShouldProcess($Name, "Remove Role Permission '$Path'")) {

            #Constructed body for the rest call
            $body = @(
                @{

                "Role"        = $Name
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

function Remove-IDRolePermission {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
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

# Confirmed live 2026-08-22: -Roles requires each role's ID/UUID, not its display name -
# consistent with every other Roles-domain finding this session (see TESTING.md Phase 3b).
function Remove-IDRole {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $false,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        [array]$Roles = @()

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess((($Roles) -join ', '), 'Remove Role')) {

            #Constructed body for the rest call
            $body = (

                $Roles

            )

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/SaasManage/DeleteRoles"
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


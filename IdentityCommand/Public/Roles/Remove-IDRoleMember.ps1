# .ExternalHelp IdentityCommand-help.xml
function Remove-IDRoleMember {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $ID,

        [Parameter(Mandatory = $false)]
        [array]$Users = @(),

        [Parameter(Mandatory = $false)]
        [array]$Roles = @(),

        [Parameter(Mandatory = $false)]
        [array]$Groups = @()

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Remove Role Member')) {

            #Constructed body for the rest call
            $body = [ordered]@{

                "Name"        = $ID
                "Users"       = $Users
                "Roles"       = $Roles
                "Groups"      = $Groups

            }

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/SaasManage/RemoveUsersAndGroupsFromRole"
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

function Remove-IDRoleMember {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $false)]
        [array]$Users = @(),

        [Parameter(Mandatory = $false)]
        [array]$Roles = @(),

        [Parameter(Mandatory = $false)]
        [array]$Groups = @()

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Remove Role Member')) {

            #Constructed body for the rest call
            $body = [ordered]@{

                "Name"        = $Name
                "Users"       = $Users
                "Roles"       = $Roles
                "Groups"      = $Groups

            }

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/SaasManage/RemoveUsersAndGroupsFromRole"
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

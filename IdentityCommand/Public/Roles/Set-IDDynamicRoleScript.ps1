function Set-IDDynamicRoleScript {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name,

        [Parameter(Mandatory = $true)]
        [string]$Script

    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Set Dynamic Role Script')) {

            #Constructed body for the rest call
            $body = "{

            'User': '$($User)',
            'Script': '$($Script)'

            }"

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Roles/SetDynamicRoleScript"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = $body
            "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end
}

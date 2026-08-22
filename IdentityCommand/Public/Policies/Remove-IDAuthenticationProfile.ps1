# .ExternalHelp IdentityCommand-help.xml
function Remove-IDAuthenticationProfile {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name
    )

    BEGIN {} #begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Remove Authentication Profile')) {

            $Body = @{

                'uuid' = $Name

            }

            #Constructed parameters for the rest call
            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/AuthProfile/DeleteProfile"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "Body"        = ($Body | ConvertTo-Json)
                "ContentType" = "application/json"

            }

            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    } #process

    END {} #end
}

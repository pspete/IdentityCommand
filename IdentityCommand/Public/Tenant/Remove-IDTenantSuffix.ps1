# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Remove-IDTenantSuffix {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        # The new tenant Suffix
        [Parameter(Mandatory = $true)]
		[array]$Suffixes

    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess((($Suffixes) -join ', '), 'Remove Tenant Suffix')) {

            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/Core/DeleteAliases"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "Body"        = ConvertTo-Json -InputObject $Suffixes
                "ContentType" = "application/json"

            }

            #Send Request
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    }#process

    END {}#end

}
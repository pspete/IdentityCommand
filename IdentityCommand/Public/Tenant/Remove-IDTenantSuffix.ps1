# .ExternalHelp IdentityCommand-help.xml
function Remove-IDTenantSuffix {
    
    [CmdletBinding()]
	param
	(
       
        # The new tenant Suffix
        [Parameter(Mandatory = $true)]
		[array]$Suffixes

    )

    BEGIN {}#begin

    PROCESS {

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

    }#process

    END {}#end

}
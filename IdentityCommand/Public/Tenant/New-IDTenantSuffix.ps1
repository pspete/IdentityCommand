# .ExternalHelp IdentityCommand-help.xml
function New-IDTenantSuffix {
    
    [CmdletBinding()]
	param
	(
       
        # The new tenant Suffix
        [Parameter(Mandatory = $true)]
		$alias,

        # Boolean if it is a Cloud directory alias
        [Parameter(Mandatory = $false)]
		$cdsAlias = $true,

        # The suffix to be mapped to the new suffix
        [Parameter(Mandatory = $true)]
		$domain,

        # Whether or not its mapping the new suffix to CDS users or AD/FDS users
        [Parameter(Mandatory = $false)]
        [ValidateSet("AD&FDS","CDS")]
		[Alias('jsutil-radio2')]
        $directory = "AD&FDS",

        # Old name, not sure what this does. Perhaps for updating an existing alias
        [Parameter(Mandatory = $false)]
		$oldname = ""

    )

    BEGIN {}#begin

    PROCESS {

        $Body = @{

            "alias"         = $alias
            "cdsAlias"      = $cdsAlias
            "domain"        = $domain
            "jsutil-radio2" = $directory
            "oldname"       = $oldname

        }

        $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Core/StoreAlias"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = ($Body | ConvertTo-JSON)
            "ContentType" = "application/json"

        }

        #Send Request
        $result = Invoke-IDRestMethod @RestCall

        return $result

    }#process

    END {}#end

}
# .ExternalHelp IdentityCommand-help.xml
function New-IDTenantCname {
    [CmdletBinding(SupportsShouldProcess)]
	param
	(

        [Parameter(Mandatory = $true)]
		$cnamePrefix

    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($cnamePrefix, 'Register Tenant Cname')) {

            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/TenantCnames/Register?cnamePrefix=$cnamePrefix"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "ContentType" = "application/json"

            }
            #Send Request
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    }#process

    END {}#end

}
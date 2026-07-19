# .ExternalHelp IdentityCommand-help.xml
function Set-IDTenantPreferredCname {
    [CmdletBinding(SupportsShouldProcess)]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$customCname

    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($customCname, 'Set Preferred Tenant Cname')) {

            if ($cnamePrefix -like "*.id.cyberark.cloud") {

                $Body = @{

                    "customCname" = $customCname

                }

            }

            else {

                $Body = @{

                    "customCname" = "$($customCname).id.cyberark.cloud"

                }
            }

            $RestCall = @{

                "URI"         = "$($ISPSSSession.tenant_url)/TenantCnames/SetPreferred"
                "Headers"     = $($ISPSSSession.WebSession.Headers)
                "Method"      = "Post"
                "Body"        = ($Body | ConvertTo-JSON)
                "ContentType" = "application/json"

            }
            #Send Request
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }

    }#process

    END {}#end

}
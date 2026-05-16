# .ExternalHelp IdentityCommand-help.xml
function Remove-IDTenantCname {
    [CmdletBinding()]
	param
	(
       
        [Parameter(Mandatory = $true)]
		$customCname

    )

    BEGIN {}#begin

    PROCESS {

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

            "URI"         = "$($ISPSSSession.tenant_url)/TenantCnames/UnRegister"
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
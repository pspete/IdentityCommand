# .ExternalHelp IdentityCommand-help.xml
function Get-IDRoleApplication {

    [CmdletBinding()]
	param
	(

        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        [Alias('Uuid')]
        $Name

    )

    BEGIN {} #begin

    PROCESS {

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "$($ISPSSSession.tenant_url)/SaasManage/GetRoleApps?role=$Name"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "ContentType" = "application/json"

        }

        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result.results.row

    } #process

    END {} #end
}

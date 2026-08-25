# .ExternalHelp IdentityCommand-help.xml
function Get-IDApplicationTemplate {
    [CmdletBinding()]
    param( )

    BEGIN {}#begin

    PROCESS {

        #Constructed parameters for the rest call
        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/GetTemplatesAndCategories"
            'Method' = 'POST'

        }

        #Send Request
        $result = Invoke-IDRestMethod @Request

        #Flatten the nested AppTemplates.Results.Row structure, keep Categories alongside it
        if ($null -ne $result) {

            [PSCustomObject]@{
                'Templates'  = $result.AppTemplates.Results.Row
                'Categories' = $result.Categories
            }

        }

    }#process

    END {}#end

}

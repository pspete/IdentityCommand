# .ExternalHelp IdentityCommand-help.xml
# TODO: Request/output shape (Templates flattened from AppTemplates.Results.Row, Categories as-is)
# has been confirmed against one live tenant response. Still unverified: whether AppTemplates.Results
# always has this exact shape (e.g. under pagination) and the full set of fields on each row.
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

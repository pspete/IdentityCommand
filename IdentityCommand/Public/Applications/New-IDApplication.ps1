# .ExternalHelp IdentityCommand-help.xml
# TODO: Request body field names ('TemplateName'/'Name') and the response object structure are
# inferred from the SaaS Manage API spec's operation summaries only - no full schema was available.
# Verify against a live tenant and adjust body key names / output shape as needed.
function New-IDApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$TemplateName,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Name
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TemplateName, 'Import Application From Template')) {

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/ImportAppFromTemplate"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

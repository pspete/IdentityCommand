# .ExternalHelp IdentityCommand-help.xml
# TODO: Request body field ('ID') and the response object structure are inferred from the SaaS
# Manage API spec's operation summaries only - no full schema was available.
# Verify against a live tenant and adjust body key names / output shape as needed.
function Test-IDApplicationCatalogAvailability {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        #Constructed parameters for the rest call
        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/IsApplicationAvailableInCatalog"
            'Method' = 'POST'
            'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

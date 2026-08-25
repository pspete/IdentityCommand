# .ExternalHelp IdentityCommand-help.xml
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

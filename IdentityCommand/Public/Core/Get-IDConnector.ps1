# .ExternalHelp IdentityCommand-help.xml
function Get-IDConnector {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('ID')]
        [String]$proxyUuid
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/Core/CheckProxyHealth"

        $queryString = $PSBoundParameters | Get-Parameter | ConvertTo-QueryString

        If ($null -ne $queryString) {

            #Build URL from base URL
            $URI = "$URI`?$queryString"

        }

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST

        if ($null -ne $result) {
            $result.Connectors
        }

    }#process

    END { }#end

}
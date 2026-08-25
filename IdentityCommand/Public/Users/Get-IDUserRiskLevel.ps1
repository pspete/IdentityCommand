# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserRiskLevel {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    begin {}#begin

    process {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserRiskLevel"
            'Method' = 'POST'
            'Body'   = (@{ 'ID' = $ID } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    end {}#end

}

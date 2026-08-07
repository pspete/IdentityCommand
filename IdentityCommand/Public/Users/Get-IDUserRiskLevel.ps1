# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserRiskLevel"
            'Method' = 'POST'
            'Body'   = (@{ 'ID' = $ID } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

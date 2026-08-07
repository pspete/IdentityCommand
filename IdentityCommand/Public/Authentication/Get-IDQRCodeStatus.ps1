# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Guid is expected to be the same client GUID generated/used by New-IDQRCodeSession, but this
# has not been confirmed end-to-end against a live tenant.
function Get-IDQRCodeStatus {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Guid
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/Security/GetQRCodeStatus"
            'Method' = 'POST'
            'Body'   = (@{ 'guid' = $Guid } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

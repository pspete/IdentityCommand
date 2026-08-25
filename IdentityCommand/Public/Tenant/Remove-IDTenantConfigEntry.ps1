# .ExternalHelp IdentityCommand-help.xml
function Remove-IDTenantConfigEntry {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Key
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Key, 'Remove Tenant Configuration Entry')) {

            $URI = "$($ISPSSSession.tenant_url)/Core/DeleteTenantConfig?key=$($Key | Get-EscapedString)"

            $Request = @{

                'URI'    = $URI
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

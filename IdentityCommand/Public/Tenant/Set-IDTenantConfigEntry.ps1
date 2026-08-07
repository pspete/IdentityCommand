# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This wraps /Core/SetTenantConfig, a different underlying config store to
# Set-IDTenantConfiguration (which wraps /TenantConfig/SetCustomerConfig) - kept as a distinct
# command/noun deliberately to avoid conflating the two. The exact set of recognised keys for
# this store is undocumented.
function Set-IDTenantConfigEntry {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Key,

        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Value
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Key, 'Set Tenant Configuration Entry')) {

            $URI = "$($ISPSSSession.tenant_url)/Core/SetTenantConfig?key=$($Key | Get-EscapedString)&value=$($Value | Get-EscapedString)"

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

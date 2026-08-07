# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This wraps /Core/DeleteTenantConfig, a different underlying config store to
# Get/Set-IDTenantConfiguration (which wrap /TenantConfig/*CustomerConfig) - kept as a distinct
# command/noun deliberately to avoid conflating the two.
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

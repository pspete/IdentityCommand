# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The set of recognised keys in -Settings is drawn from a single recorded sample request
# (CyberArk-REST-API-Bruno) and may not be exhaustive - the API may accept additional keys not
# listed in this command's help, and it's unclear whether this is a partial update (only supplied
# keys change) or a full replace of the tenant's custom configuration.
function Set-IDTenantConfiguration {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Hashtable]$Settings
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Set Tenant Custom Configuration')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/TenantConfig/SetCustomerConfig"
                'Method' = 'POST'
                'Body'   = ($Settings | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

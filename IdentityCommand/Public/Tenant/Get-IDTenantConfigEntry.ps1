# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This wraps /Core/GetTenantConfig, a different underlying config store to
# Get-IDTenantConfiguration (which wraps /TenantConfig/GetCustomerConfig) - kept as a distinct
# command/noun deliberately to avoid conflating the two. The exact set of recognised keys for
# this store is undocumented.
function Get-IDTenantConfigEntry {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Key,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Default
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/Core/GetTenantConfig?key=$($Key | Get-EscapedString)"

        if ($PSBoundParameters.ContainsKey('Default')) {

            $URI = "$URI&dflt=$($Default | Get-EscapedString)"

        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

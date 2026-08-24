# .ExternalHelp IdentityCommand-help.xml
# TODO: The exact set of recognised keys for this config store is undocumented.
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

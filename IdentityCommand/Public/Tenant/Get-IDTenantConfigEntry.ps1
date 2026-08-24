# .ExternalHelp IdentityCommand-help.xml
# TODO: The exact set of recognised keys for this config store is undocumented.
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

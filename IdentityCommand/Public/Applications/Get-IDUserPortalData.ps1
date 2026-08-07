# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDUserPortalData {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [String]$Username,

        [parameter(Mandatory = $false)]
        [String]$Force
    )

    BEGIN {}#begin

    PROCESS {

        $Query = @{}

        if ($PSBoundParameters.ContainsKey('Force')) { $Query['force'] = $Force }
        if ($PSBoundParameters.ContainsKey('Username')) { $Query['username'] = $Username }

        $URI = "$($ISPSSSession.tenant_url)/UPRest/GetUPData"

        if ($Query.Count -gt 0) {

            $URI = "$URI`?$($Query | ConvertTo-QueryString)"

        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'
            'Body'   = (@{} | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

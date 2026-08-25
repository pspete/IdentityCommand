# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserPortalData {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [String]$Username,

        [parameter(Mandatory = $false)]
        [Switch]$Force
    )

    BEGIN {}#begin

    PROCESS {

        $Query = @{}

        if ($Force.IsPresent) { $Query['force'] = $Force.IsPresent.ToString().ToLower() }
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

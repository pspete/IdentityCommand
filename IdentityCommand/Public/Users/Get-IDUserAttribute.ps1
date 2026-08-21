# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
# TODO: -directoryServiceUUID uses lowercase-first casing to match the underlying API's query
# parameter name exactly (consistent with -username on Get-IDUser), rather than standard PowerShell
# parameter casing.
function Get-IDUserAttribute {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$directoryServiceUUID
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserAttributes"

        $QueryString = $PSBoundParameters | Get-Parameter | ConvertTo-QueryString

        if ($QueryString) {

            $URI = "$URI`?$QueryString"

        }

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}

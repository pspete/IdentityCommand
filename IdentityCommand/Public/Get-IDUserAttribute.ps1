# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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

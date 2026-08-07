# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDUserHierarchy {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserHierarchy"

        if ($PSBoundParameters.ContainsKey('ID')) {

            $URI = "$URI`?ID=$($ID | Get-EscapedString)"

        }

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}

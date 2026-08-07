# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDRecentImportedAccountsFile {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [Int]$FileCount
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UPRest/GetRecentImportedAccountsFile"

        if ($PSBoundParameters.ContainsKey('FileCount')) {

            $URI = "$URI`?fileCount=$($FileCount | Get-EscapedString)"

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

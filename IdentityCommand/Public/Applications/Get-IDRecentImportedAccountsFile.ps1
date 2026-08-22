# .ExternalHelp IdentityCommand-help.xml
# TODO: -FileCount is required in practice - a call with no arguments fails server-side with a
# generic HTML error page rather than a JSON error, even though the recorded Bruno sample didn't
# indicate it was mandatory.
function Get-IDRecentImportedAccountsFile {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [Int]$FileCount
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetRecentImportedAccountsFile`?fileCount=$($FileCount | Get-EscapedString)"
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

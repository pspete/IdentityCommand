# .ExternalHelp IdentityCommand-help.xml
function Get-IDPersonalApplicationImportFile {
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

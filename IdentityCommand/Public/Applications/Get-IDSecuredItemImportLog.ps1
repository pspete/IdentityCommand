# .ExternalHelp IdentityCommand-help.xml
function Get-IDSecuredItemImportLog {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$FileKey
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/DownloadImportAccountsLogFile`?fileKey=$($FileKey | Get-EscapedString)"
            'Method' = 'POST'

        }

        #Send Request
        $Result = Invoke-IDRestMethod @Request

        #The response is a CSV file - Get-IDResponse has no handling for application/csv, so
        #Invoke-WebRequest hands back the raw, undecoded bytes. These arrive here as [Object[]],
        #not [Byte[]] - the pipeline between Get-IDResponse and here unrolls then recollects the
        #array, losing its element type - so check for [Array] generally and cast explicitly
        if ($Result -is [Array]) {

            $Bytes = [Byte[]]$Result
            $Text = [System.Text.Encoding]::UTF8.GetString($Bytes).TrimStart([Char]0xFEFF)
            $Result = $Text | ConvertFrom-Csv

        }

        $Result

    }#process

    END {}#end

}

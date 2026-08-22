# .ExternalHelp IdentityCommand-help.xml
function Get-IDApplicationTag {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetTagsForApp`?appkey=$($AppKey | Get-EscapedString)"
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

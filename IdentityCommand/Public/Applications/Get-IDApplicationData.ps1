# .ExternalHelp IdentityCommand-help.xml
function Get-IDApplicationData {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [Boolean]$MarkAppVisited = $false
    )

    begin {}#begin

    process {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetAppByKey`?appkey=$($AppKey | Get-EscapedString)"
            'Method' = 'POST'
            'Body'   = (@{ 'markAppVisited' = "$MarkAppVisited" } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    end {}#end

}

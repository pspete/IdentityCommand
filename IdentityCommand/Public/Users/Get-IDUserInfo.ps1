# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserInfo {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    begin {}#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserInfo?ID=$($ID | Get-EscapedString)"

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    end {}#end

}

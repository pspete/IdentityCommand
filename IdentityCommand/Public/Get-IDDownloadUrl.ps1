# .ExternalHelp IdentityCommand-help.xml
function Get-IDDownloadUrl {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$($ISPSSSession.tenant_url)/Core/GetDownloadUrls"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
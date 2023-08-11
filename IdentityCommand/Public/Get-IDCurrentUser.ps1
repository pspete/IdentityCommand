# .ExternalHelp IdentityCommand-help.xml
function Get-IDCurrentUser {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$Script:tenant_url/CDirectoryService/GetUserAttributes"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
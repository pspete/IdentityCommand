# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenant {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$Script:tenant_url/SysInfo/About"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
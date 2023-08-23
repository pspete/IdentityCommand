# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserIdentifier {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$Script:tenant_url/UserIdentifiers/Get"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
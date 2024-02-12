# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantCname {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$($ISPSSSession.tenant_url)/TenantCnames/UiGet"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
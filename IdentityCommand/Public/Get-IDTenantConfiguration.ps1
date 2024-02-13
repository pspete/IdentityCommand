# .ExternalHelp IdentityCommand-help.xml
function Get-IDTenantConfiguration {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$($ISPSSSession.tenant_url)/TenantConfig/GetCustomerConfig"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}
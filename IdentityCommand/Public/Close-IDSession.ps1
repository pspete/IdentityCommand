# .ExternalHelp IdentityCommand-help.xml
function Close-IDSession {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$Script:tenant_url/Security/Logout"

    }#begin

    PROCESS {

        #Send Logoff Request
        Invoke-IDRestMethod -Uri $URI -Method POST | Out-Null

    }#process

    END {

        #Remove Module scope variables on logoff
        Remove-Variable -Name tenant_url -Scope Script -ErrorAction SilentlyContinue
        Remove-Variable -Name TenantId -Scope Script -ErrorAction SilentlyContinue
        Remove-Variable -Name WebSession -Scope Script -ErrorAction SilentlyContinue

    }#end

}
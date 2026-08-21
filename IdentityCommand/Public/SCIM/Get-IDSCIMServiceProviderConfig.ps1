# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Get-IDSCIMServiceProviderConfig {
    [CmdletBinding()]
    param()

    BEGIN {}#begin

    PROCESS {

        #Send Request
        Invoke-IDSCIMRequest -Resource 'ServiceProviderConfig' -Method 'GET'

    }#process

    END {}#end

}

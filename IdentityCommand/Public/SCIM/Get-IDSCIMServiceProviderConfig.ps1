# .ExternalHelp IdentityCommand-help.xml
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

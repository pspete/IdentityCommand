# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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

# .ExternalHelp IdentityCommand-help.xml
function Get-IDCredentialProvider {
    [CmdletBinding()]
    param()

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetCredentialsProviderListForImport"
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

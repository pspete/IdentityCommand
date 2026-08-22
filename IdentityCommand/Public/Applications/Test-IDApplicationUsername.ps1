# .ExternalHelp IdentityCommand-help.xml
function Test-IDApplicationUsername {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Username
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/ValidateUsernameIsAllowed"
            'Method' = 'POST'
            'Body'   = (@{ 'userName' = $Username } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

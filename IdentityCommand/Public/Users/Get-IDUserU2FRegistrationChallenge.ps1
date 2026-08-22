# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserU2FRegistrationChallenge {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [String]$AuthenticatorType = 'SECURITYKEY',

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$UserDefinedName
    )

    BEGIN {}#begin

    PROCESS {

        $Body = @{
            'authenticatorType' = $AuthenticatorType
            'userDefinedName'   = $UserDefinedName
        }

        #A browser always sends an Origin header, which this endpoint appears to require to
        #determine the WebAuthn relying-party host - Invoke-WebRequest doesn't send one by
        #default, causing "Unexpected null arguments passed to the server." without it
        $Request = @{

            'URI'     = "$($ISPSSSession.tenant_url)/U2f/GetRegistrationChallenge"
            'Method'  = 'POST'
            'Body'    = ($Body | ConvertTo-Json)
            'Headers' = @{ 'Origin' = $ISPSSSession.tenant_url }

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

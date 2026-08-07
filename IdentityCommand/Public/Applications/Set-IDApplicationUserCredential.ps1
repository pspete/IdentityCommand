# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Set-IDApplicationUserCredential {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [String]$Username,

        [parameter(Mandatory = $false)]
        [SecureString]$Password,

        [parameter(Mandatory = $false)]
        [String]$PublicKeyHash,

        [parameter(Mandatory = $false)]
        [String]$ConnectorId
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Set Application User Credentials')) {

            $Body = [ordered]@{
                'appkey'        = $AppKey
                'Username'      = $Username
                'PublicKeyHash' = $PublicKeyHash
                'ConnectorId'   = $ConnectorId
            }

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ($Password | ConvertTo-InsecureString)

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/SetUserCredsForApp"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

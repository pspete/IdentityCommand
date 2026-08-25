# .ExternalHelp IdentityCommand-help.xml
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
                #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of
                #this call records a non-revealing type name instead of the literal request content
                'Body'   = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json -Depth 6))

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# TODO: Per the vendor's OpenAPI schema, -PublicKey is `string($byte)` - base64-encoded bytes.
# Which DER format those bytes must decode to (X.509 SubjectPublicKeyInfo vs PKCS#1 RSAPublicKey)
# is still unconfirmed - untested with a base64-encoded key.
# TODO: Per the vendor's API docs, the response returns the secret encrypted under an 'e' property
# (RSA-OAEP with the supplied -PublicKey) if encryption succeeds, or plain text under a 'p'
# property if it fails. Decrypting an 'e' response is left to the caller - this command does not
# attempt decryption.
function Get-IDApplicationClientSecret {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey', 'ID')]
        [String]$OIDCAppKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$PublicKey
    )

    BEGIN {}#begin

    PROCESS {

        $Body = [ordered]@{
            'OIDCAppKey' = $OIDCAppKey
            'PublicKey'  = $PublicKey
        }

        #Constructed parameters for the rest call
        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/GetOpenIdClientSecret"
            'Method' = 'POST'
            'Body'   = ($Body | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

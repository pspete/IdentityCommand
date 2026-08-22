# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - -PublicKey's exact expected wire format is unconfirmed. Three plausible
# encodings (X.509 SubjectPublicKeyInfo DER, PKCS#1 RSAPublicKey DER, JWK JSON) were all rejected
# with "Invalid PublicKey". Needs a real request captured via browser DevTools.
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

# .ExternalHelp IdentityCommand-help.xml
# -OIDCAppKey confirmed correct against a live tenant - the server accepts it without complaint.
# -PublicKey's exact expected wire format is UNCONFIRMED and DEPRIORITIZED: three plausible
# encodings (X.509 SubjectPublicKeyInfo DER, PKCS#1 RSAPublicKey DER, JWK JSON) were tried live and
# all rejected identically with "Invalid PublicKey"; a 4th (.NET RSA XML) was rejected separately by
# ASP.NET request validation before reaching the endpoint. Not actively being pursued further -
# capturing a real request via browser DevTools would be the most reliable next step if revisited.
# TODO: Per the vendor's own API docs, the response returns the secret in encrypted form under an
# 'e' property (encrypted with the supplied -PublicKey, RSA-OAEP) if encryption succeeds, or in
# plain text under a 'p' property if it fails. Decrypting an 'e' response (requires the matching
# RSA private key) is left to the caller - this command does not attempt decryption.
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

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - fails with a generic HTML error page, suggesting the endpoint URL and/or
# body shape is wrong. No sample request was ever found for this endpoint - the -ID parameter/body
# shape was inferred purely by analogy with other single-user CDirectoryService operations. Needs a
# DevTools capture of whatever portal flow triggers an identity-verification OTP send.
function Send-IDUserIdentityVerification {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Send Identity Verification')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/SendIdentityVerification"
                'Method' = 'POST'
                'Body'   = (@{ 'ID' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

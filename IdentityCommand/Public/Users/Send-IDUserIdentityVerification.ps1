# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21, failed on the first attempt with a generic Idaptive
# "Something went wrong" HTML error page (not a JSON error), suggesting the endpoint URL and/or body
# shape is wrong. No sample request was ever found for this endpoint anywhere checked (Bruno
# collection or swagger schema) - only the operation's existence and one-line summary ("Send
# SendIdentityVerificationOTP to a specified user"). The -ID parameter/body shape was inferred
# purely by analogy with other single-user CDirectoryService operations, with no way to form a
# stronger follow-up guess. Not being pursued further; next step if revisited is a DevTools capture
# of whatever portal flow triggers an identity-verification OTP send.
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

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: The full success path (an SMS actually being sent) is unconfirmed - re-test with a
# user that has a mobile number.
# TODO: No real sample request exists for this endpoint - this command's shape (query string,
# single ID) is inferred by analogy with Get-IDUserInfo/Test-IDUserLockedOutByPolicy rather than
# confirmed.
function Send-IDUserSmsInvite {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Send SMS Invite')) {

            $URI = "$($ISPSSSession.tenant_url)/UserMgmt/SendSmsInvite?ID=$($ID | Get-EscapedString)"

            #Send Request
            Invoke-IDRestMethod -Uri $URI -Method POST

        }

    }#process

    END {}#end

}

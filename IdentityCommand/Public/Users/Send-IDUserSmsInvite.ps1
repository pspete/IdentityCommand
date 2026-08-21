# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: The request pipeline is confirmed live (server correctly rejected a phone-less test
# user with "no mobile phone number in profile"), but the full success path (an SMS actually being
# sent) is unconfirmed - re-test with a user that has a mobile number.
# TODO: The recorded sample request for this operation was mislabeled in its source (it pointed at
# the same URL as Send-IDUserLoginEmail's SendLoginEmails endpoint) so no real sample exists for
# SendSmsInvite specifically. This command's shape (query string, single ID) is inferred by analogy
# with Get-IDUserInfo/Test-IDUserLockedOutByPolicy rather than confirmed.
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

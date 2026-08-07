# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Entities expects an array of hashtables shaped like the recorded sample, e.g.
# @{Type='user'; Guid='<userUUID>'; Name='<userName>'}, @{Type='group'; Guid='<groupUUID>'},
# @{Type='role'; Guid='<roleUUID>'} - the exact required/optional fields per Type are unconfirmed.
function Send-IDUserInvite {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Role,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Array]$Entities,

        [parameter(Mandatory = $false)]
        [Switch]$EmailInvite,

        [parameter(Mandatory = $false)]
        [Switch]$SmsInvite,

        [parameter(Mandatory = $false)]
        [Switch]$GroupInvite
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Role, 'Send User Invite')) {

            $Body = [ordered]@{
                'EmailInvite' = [Bool]$EmailInvite
                'GroupInvite' = [Bool]$GroupInvite
                'SmsInvite'   = [Bool]$SmsInvite
                'Role'        = $Role
                'Entities'    = $Entities
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/InviteUsers"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

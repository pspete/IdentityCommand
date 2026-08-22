# .ExternalHelp IdentityCommand-help.xml
# TODO: CAUTION - this is SELF-SERVICE ONLY: it always changes the
# password of whichever account the current session is authenticated as (UserMgmt/ChangeUserPassword
# has no user-targeting field, and $ISPSSSession.User is only used for the -WhatIf/-Confirm message,
# not sent in the request body). There is no way to change another user's password via this command
# - confirmed live when it changed the calling admin's own live password rather than a disposable
# test user's, because -OldPassword didn't match the session's real current password but the
# request still succeeded (the server does not appear to validate -OldPassword against the session
# user's actual current password either).
function Set-IDUserPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [SecureString]$OldPassword,

        [parameter(Mandatory = $true)]
        [SecureString]$NewPassword
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.User, 'Change User Password')) {

            $Body = [ordered]@{
                'oldPassword' = ($OldPassword | ConvertTo-InsecureString)
                'newPassword' = ($NewPassword | ConvertTo-InsecureString)
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/ChangeUserPassword"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

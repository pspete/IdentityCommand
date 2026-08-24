# .ExternalHelp IdentityCommand-help.xml
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

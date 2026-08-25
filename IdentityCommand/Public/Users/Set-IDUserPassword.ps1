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
                #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of
                #this call records a non-revealing type name instead of the literal request content
                'Body'   = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json -Depth 6))

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

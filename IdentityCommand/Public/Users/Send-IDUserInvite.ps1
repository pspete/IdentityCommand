# .ExternalHelp IdentityCommand-help.xml
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

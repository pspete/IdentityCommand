# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded sample request body has no 'Id' field, only 'Culture' and 'Question' - this
# suggests the underlying API only supports adding a new question, not updating an existing one by
# ID, despite the 'Set' verb in its name. Confirm whether an update-by-ID path exists.
function Set-IDTenantSecurityQuestion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Question,

        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Culture = 'all'
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Question, 'Add Tenant Security Question')) {

            $Body = [ordered]@{
                'Culture'  = $Culture
                'Question' = $Question
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/TenantConfig/SetAdminSecurityQuestion"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

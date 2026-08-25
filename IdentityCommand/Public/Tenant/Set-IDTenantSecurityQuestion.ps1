# .ExternalHelp IdentityCommand-help.xml
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

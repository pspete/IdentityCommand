# .ExternalHelp IdentityCommand-help.xml
# TODO: Confirmed live - this only ever adds a new question - there is no update-by-ID path
# despite the 'Set' verb (matches the TODO's original suspicion, since the request body has no
# 'Id' field). The response itself carries no ID either - use Get-IDTenantSecurityQuestion
# afterward to find the new question's Uuid (needed by Remove-IDTenantSecurityQuestion).
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

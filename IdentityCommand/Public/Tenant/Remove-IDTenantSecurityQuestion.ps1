# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Remove-IDTenantSecurityQuestion {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Remove Tenant Security Question')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/TenantConfig/DeleteAdminSecurityQuestion"
                'Method' = 'POST'
                'Body'   = (@{ 'Id' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

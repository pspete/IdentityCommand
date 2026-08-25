# .ExternalHelp IdentityCommand-help.xml
function Remove-IDOrganization {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Remove Organization')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/Delete"
                'Method' = 'POST'
                'Body'   = (@{ 'OrgId' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

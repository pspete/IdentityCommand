# .ExternalHelp IdentityCommand-help.xml
function Remove-IDOrganization {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$OrgId
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($OrgId, 'Remove Organization')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/Delete"
                'Method' = 'POST'
                'Body'   = (@{ 'OrgId' = $OrgId } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

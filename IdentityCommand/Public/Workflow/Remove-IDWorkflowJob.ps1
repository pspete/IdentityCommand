# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function Remove-IDWorkflowJob {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$JobId
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($JobId, 'Delete Workflow Job')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/JobFlow/DeleteJob"
                'Method' = 'POST'
                'Body'   = (@{ 'jobid' = $JobId } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

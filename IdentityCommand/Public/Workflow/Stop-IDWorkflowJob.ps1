# .ExternalHelp IdentityCommand-help.xml
# TODO: Retest against a genuinely pending/in-progress job to see the full success response shape.
function Stop-IDWorkflowJob {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$JobId,

        [parameter(Mandatory = $false)]
        [String]$Reason
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($JobId, 'Cancel Workflow Job')) {

            $Body = [ordered]@{
                'jobId'  = $JobId
                'reason' = $Reason
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Task/CancelJob"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

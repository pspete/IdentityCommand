# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant - confirmed correct, returns "NotFound" for an already-terminated
# job (legitimate, matches Send-IDWorkflowEvent's confirmed pipeline). Retest against a genuinely
# pending/in-progress job to see the full success response shape.
# TODO: The recorded Bruno sample for this endpoint (Task/CancelJob) is named "Start Job.bru" - the
# filename appears to be mislabeled relative to the URL/body shape. The URL and body ("jobId",
# "reason") are trusted here as the correct description of a job-cancel operation.
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

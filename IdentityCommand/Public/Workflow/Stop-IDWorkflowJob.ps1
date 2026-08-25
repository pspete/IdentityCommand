# .ExternalHelp IdentityCommand-help.xml
# TODO: Shape confirmed correct against the vendor's Task Management OpenAPI spec ({jobId, reason},
# both required). calls against a genuinely pending job failed regardless - "unauthorized" as
# the job's own initiator, "NotFound" as an admin - but the JobId used was a WorkFlowJob (JobFlow)
# ID, not a Task ID; per the vendor spec, /Task/CancelJob operates on a distinct "Task" system, so
# this may simply need a real Task ID rather than a WorkFlowJob ID to work. Unclear what produces a
# Task ID, or whether cancelling a pending access-request approval is even a Task in this sense.
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

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Reason
    )

    begin {}#begin

    process {

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

    end {}#end

}

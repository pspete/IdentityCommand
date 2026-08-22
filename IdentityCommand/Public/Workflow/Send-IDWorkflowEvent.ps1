# .ExternalHelp IdentityCommand-help.xml
# TODO: The request/response pipeline is confirmed correct - sending an 'Approve' event to an
# already-completed job correctly returned "Workflow is in state Failed and may not accept further
# input." (a legitimate business-state rejection, not a code error). Retest against a genuinely
# pending/in-progress job to confirm the full success path. -Args expects a hashtable shaped like
# the event's expected argument payload - the recorded sample only shows an empty object ({}), so
# the real shape is unconfirmed.
function Send-IDWorkflowEvent {
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
        [String]$Event,

        [parameter(Mandatory = $false)]
        [Boolean]$Sync = $true,

        [parameter(Mandatory = $false)]
        [Hashtable]$Args = @{}
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($JobId, "Send Workflow Event '$Event'")) {

            $Body = [ordered]@{
                'jobid' = $JobId
                'sync'  = $Sync
                'args'  = $Args
                'event' = $Event
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/JobFlow/Event"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

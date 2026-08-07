# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded Bruno sample for this endpoint (JobFlow/StartJob) is named "Cancel Job.bru" -
# the filename appears to be mislabeled relative to the URL/body shape. The URL and body ("args",
# "script") are trusted here as the correct description of a job-start operation.
function Start-IDWorkflowJob {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Script,

        [parameter(Mandatory = $false)]
        [String]$Args
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Script, 'Start Workflow Job')) {

            $Body = [ordered]@{
                'script' = $Script
                'args'   = $Args
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/JobFlow/StartJob"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

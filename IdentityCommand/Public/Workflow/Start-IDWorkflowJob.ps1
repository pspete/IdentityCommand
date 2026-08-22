# .ExternalHelp IdentityCommand-help.xml
# TODO: -Script must be a real virtual script path starting with a forward slash (e.g.
# '/lib/get_superrights.js'). -Args must be a dictionary/hashtable of named parameters matching
# what the target script expects (e.g. @{excludeRight=''} for get_superrights.js), not a bare
# string or positional array. On success, the response Result is the new job's ID as a plain
# string (not an object with a .jobid property) - this command's return value IS the job ID.
function Start-IDWorkflowJob {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Script,

        [parameter(Mandatory = $false)]
        [Hashtable]$Args = @{}
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

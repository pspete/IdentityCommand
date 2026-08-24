# .ExternalHelp IdentityCommand-help.xml
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

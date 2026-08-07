# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDWorkflowJobReport {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$HoursBack
    )

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/Task/JobReport"

        if ($PSBoundParameters.ContainsKey('HoursBack')) {

            $URI = "$URI`?hoursBack=$($HoursBack | Get-EscapedString)"

        }

        $Request = @{

            'URI'    = $URI
            'Method' = 'POST'

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
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

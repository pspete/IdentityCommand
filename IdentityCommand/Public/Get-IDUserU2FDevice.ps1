# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Get-IDUserU2FDevice {
    [CmdletBinding()]
    param(
        [parameter(Mandatory = $false)]
        [String]$Type
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSBoundParameters.ContainsKey('Type')) {

            $URI = "$($ISPSSSession.tenant_url)/U2f/GetU2fDevicesForUser`?type=$($Type | Get-EscapedString)"

        } else {

            $URI = "$($ISPSSSession.tenant_url)/U2f/GetU2fDevices"

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

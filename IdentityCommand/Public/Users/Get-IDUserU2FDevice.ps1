# .ExternalHelp IdentityCommand-help.xml
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
        $result = Invoke-IDRestMethod @Request

        if ($null -ne $result) {

            #GetU2fDevices/GetU2fDevicesForUser returns a RedRock-style query envelope -
            #flatten to the actual device rows, matching the convention used elsewhere.
            $result.Results.Row

        }

    }#process

    END {}#end

}

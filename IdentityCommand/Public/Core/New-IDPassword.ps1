# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - Core/GeneratePassword returns a generic "Something went wrong" HTML error
# page (not a JSON error), and the alternate guess UserMgmt/GeneratePassword 404s outright. The
# endpoint name/path is unconfirmed. Needs a real request captured via browser DevTools - open the
# admin portal's "generate password" action (e.g. on a user's account page) if one exists.
function New-IDPassword {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [Int]$Length
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Generate Password')) {

            $URI = "$($ISPSSSession.tenant_url)/Core/GeneratePassword"

            if ($PSBoundParameters.ContainsKey('Length')) {

                $URI = "$URI`?passwordLength=$($Length | Get-EscapedString)"

            }

            $Request = @{

                'URI'    = $URI
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

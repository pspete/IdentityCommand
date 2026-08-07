# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
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

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Remove-IDUserU2FDevice {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$KeyHandle
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($KeyHandle -join ', '), 'Delete U2F Device(s)')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/U2f/DeleteU2fDevices"
                'Method' = 'POST'
                'Body'   = (@{ 'KeyHandles' = @($KeyHandle) } | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

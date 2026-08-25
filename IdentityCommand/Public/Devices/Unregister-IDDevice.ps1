# .ExternalHelp IdentityCommand-help.xml
function Unregister-IDDevice {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$DeviceID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($DeviceID, 'Unenroll Device')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Mobile/RemoveDeviceProfile`?deviceID=$($DeviceID | Get-EscapedString)"
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

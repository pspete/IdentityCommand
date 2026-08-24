# .ExternalHelp IdentityCommand-help.xml
function Remove-IDDevice {
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

        if ($PSCmdlet.ShouldProcess($DeviceID, 'Delete Device')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Mobile/DeleteDevice`?deviceID=$($DeviceID | Get-EscapedString)"
                'Method' = 'POST'

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# TODO: -DeviceID is the literal value supplied to New-IDDevice's -Udid at creation, not a
# server-generated ID - look devices up via Invoke-IDSqlcmd against the Device Redrock table if
# you don't already have the ID (no Get-IDDevice command exists).
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

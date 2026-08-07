# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Update-IDUserApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [String]$Notes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Update User Application')) {

            $Body = [ordered]@{
                'appkey' = $AppKey
                'notes'  = $Notes
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdateUserApplication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

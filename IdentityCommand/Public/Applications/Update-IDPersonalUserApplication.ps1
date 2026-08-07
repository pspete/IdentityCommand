# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Update-IDPersonalUserApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [String]$AppName,

        [parameter(Mandatory = $false)]
        [String]$AppDescription,

        [parameter(Mandatory = $false)]
        [String]$Notes,

        [parameter(Mandatory = $false)]
        [String]$AppUrl
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Update Personal User Application')) {

            $Body = [ordered]@{
                'appName'        = $AppName
                'appkey'         = $AppKey
                'appDescription' = $AppDescription
                'notes'          = $Notes
                'appUrl'         = $AppUrl
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdatePersonalApplication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

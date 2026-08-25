# .ExternalHelp IdentityCommand-help.xml
function Import-IDApplicationTemplate {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess(($ID -join ', '), 'Import Application(s) from Template')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/ImportAppFromTemplate"
                'Method' = 'POST'
                'Body'   = (@{ 'ID' = @($ID) } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

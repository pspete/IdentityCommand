# .ExternalHelp IdentityCommand-help.xml
function Remove-IDApplicationTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$TagName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TagName, 'Delete Application Tag')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/DeleteTag"
                'Method' = 'POST'
                'Body'   = (@{ 'tagname' = $TagName } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

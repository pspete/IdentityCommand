# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function New-IDApplicationTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$TagName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TagName, 'Create Application Tag')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/CreateTagWithNoApp"
                'Method' = 'POST'
                'Body'   = (@{ 'tagname' = $TagName } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

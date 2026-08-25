# .ExternalHelp IdentityCommand-help.xml
function Send-IDUserLoginEmail {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String[]]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess((($ID) -join ', '), 'Send Login Email')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/SendLoginEmails"
                'Method' = 'POST'
                'Body'   = (@{ 'ID' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Remove-IDUser {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [Alias('Uuid')]
        [array]$ID = @()
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess((($ID) -join ', '), 'Remove Users')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/RemoveUsers"
                'Method' = 'POST'
                'Body'   = (@{ 'Users' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
function Reset-IDUserSecurityQuestion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Reset User Security Questions')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/ResetSecurityQuestions"
                'Method' = 'POST'
                'Body'   = (@{ 'Id' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

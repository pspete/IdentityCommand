# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - SaasManage/TransferOwnership rejects every guessed body shape with a
# generic "Invalid payload!". It's also unconfirmed whether TransferOwnership is even scoped to
# applications, or some other item type a user can own/share. Needs a real request captured via
# browser DevTools.
function Set-IDApplicationOwner {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'AppKey')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$NewOwner
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, "Transfer ownership to '$NewOwner'")) {

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/TransferOwnership"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

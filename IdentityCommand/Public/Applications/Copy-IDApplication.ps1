# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - /SaasManage/CloneAnApplication returns HTTP 404; the endpoint path is
# likely wrong (two guessed alternates, CloneApplication and CopyApplication, also 404'd). Needs a
# real endpoint name/body shape captured via browser DevTools. In the meantime, use
# New-IDApplication/Import-IDApplicationTemplate to build test application fixtures instead.
function Copy-IDApplication {
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
        [String]$Name
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, "Clone Application as '$Name'")) {

            #Constructed body for the rest call
            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/SaasManage/CloneAnApplication"
                'Method' = 'POST'
                'Body'   = ($PSBoundParameters | Get-Parameter | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

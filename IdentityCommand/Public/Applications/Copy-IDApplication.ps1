# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21. /SaasManage/CloneAnApplication returns a genuine
# HTTP 404 "page not found" (not a validation/body error), meaning this endpoint path is almost
# certainly wrong - it doesn't match this domain's confirmed terse Verb+Noun naming pattern
# (GetApplication, DeleteApplication, UpdateApplicationDE, TransferOwnership,
# SetApplicationPermissions, ImportAppFromTemplate - no articles). Two guessed alternates
# (CloneApplication, CopyApplication) also 404'd. Not being pursued further by guessing; needs a
# real request captured via browser DevTools from the CyberArk Identity admin portal's "duplicate
# application" UI action (if one exists) to find the real endpoint name/body shape. In the
# meantime, use New-IDApplication/Import-IDApplicationTemplate (confirmed endpoint,
# SaasManage/ImportAppFromTemplate) to build test application fixtures instead of cloning.
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

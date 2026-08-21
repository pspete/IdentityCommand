# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21. Three body-shape guesses against
# SaasManage/TransferOwnership all failed identically with a generic "Invalid payload!" (no useful
# diagnostic detail): (1) {ID, NewOwner=<bare UUID>}; (2) same plus RowKey/PVID alongside ID
# (confirmed needed by the sibling Set-IDApplicationPermission, but not this endpoint); (3)
# NewOwner as a rich principal object (SystemName/PrincipalId/DirectoryServiceUuid/Type, matching
# Set-IDApplicationPermission's confirmed Grants shape). This command's own original TODO already
# flagged deep uncertainty about whether TransferOwnership is even scoped to applications at all,
# or some other item type a user can own/share - the spec's grouping for this operation was
# ambiguous to begin with. Not being pursued further by guessing; next step if revisited is a
# DevTools capture of whatever admin portal action actually transfers ownership of an application
# (if one exists in the UI).
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

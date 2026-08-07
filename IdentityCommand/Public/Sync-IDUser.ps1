# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: No sample request was found for this endpoint anywhere checked (Bruno collection or
# swagger schema) - only the operation's existence and one-line summary ("Migrated user objects
# synchronise with the cloud directory service"). The -ID parameter/body shape is inferred purely
# by analogy with other single-user CDirectoryService operations and is unverified. It's also
# unclear whether this targets a single user or operates tenant-wide with no input.
function Sync-IDUser {
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

        if ($PSCmdlet.ShouldProcess($ID, 'Sync User')) {

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/UserSync"
                'Method' = 'POST'
                'Body'   = (@{ 'ID' = $ID } | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - live-tested 2026-08-21. The overall shape (Id/Added/Deleted/Replace) is
# accepted by the server (no "Invalid arguments" style rejection), but the exact field names
# expected inside each -Added entry are unconfirmed. Two guesses both failed identically with
# "Question may not be empty or only whitepsace." despite a non-empty value being sent:
# @{Question=...; Answer=...} and @{question=...; answer=...} (case wasn't the issue - both
# rejected the same way). Set-IDTenantSecurityQuestion (a different, tenant-level endpoint with no
# Answer field at all) doesn't confirm the field names either - it was a weak analogy to begin with.
# Not being pursued further by guessing; -Deleted's shape (presumably an array of existing question
# IDs) is also unconfirmed as a result. Next step if revisited is a DevTools capture of the admin
# portal's security-question setup UI.
function Set-IDUserSecurityQuestion {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [Array]$Added = @(),

        [parameter(Mandatory = $false)]
        [Array]$Deleted = @(),

        [parameter(Mandatory = $false)]
        [Switch]$Replace
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Security Questions')) {

            $Body = [ordered]@{
                'Id'      = $ID
                'Added'   = $Added
                'Deleted' = $Deleted
                'Replace' = [Bool]$Replace
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UserMgmt/UpdateSecurityQuestions"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

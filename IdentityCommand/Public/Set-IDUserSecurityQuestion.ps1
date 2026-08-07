# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The exact shape of entries in -Added is unconfirmed (the recorded sample just showed an
# empty object placeholder) - likely something like @{Question='...'; Answer='...'} by analogy with
# Set-IDTenantSecurityQuestion, but unverified. -Deleted is an array of existing question IDs.
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

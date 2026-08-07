# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This orchestrates two API calls (GetUsersFromCsvFile then SubmitUploadedFile) based on a
# recorded sample request - it's unclear how/where the CSV file itself is actually uploaded to the
# tenant beforehand (this command assumes -FileName refers to a file the tenant already knows
# about, matching the recorded sample's use of a filename string rather than file content).
function Import-IDUserCsv {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$FileName,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$AdminEmail,

        [parameter(Mandatory = $false)]
        [Hashtable]$DefaultSettings = @{},

        [parameter(Mandatory = $false)]
        [Switch]$SendEmailInvite,

        [parameter(Mandatory = $false)]
        [Switch]$SendSMSInvite
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($FileName, 'Import Users From CSV')) {

            #Step 1: register the file and its default field values
            $Registration = Start-UsersCsvUpload -FileName $FileName -Settings $DefaultSettings

            $ReturnID = $Registration.ReturnID

            if ($null -ne $ReturnID) {

                #Step 2: commit the import using the ReturnID from step 1
                Submit-UsersCsvUpload -ReturnID $ReturnID -AdminEmail $AdminEmail -SendEmailInvite:$SendEmailInvite -SendSMSInvite:$SendSMSInvite

            }

        }

    }#process

    END {}#end

}

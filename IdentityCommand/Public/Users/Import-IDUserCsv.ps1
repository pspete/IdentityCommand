# .ExternalHelp IdentityCommand-help.xml
function Import-IDUserCsv {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
        [String]$Path,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$AdminEmail,

        [parameter(Mandatory = $false)]
        [Switch]$SendEmailInvite,

        [parameter(Mandatory = $false)]
        [Switch]$SendSMSInvite
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Path, 'Import Users From CSV')) {

            #Step 1: upload the file, returning a preview of the parsed rows and a ReturnID
            $Registration = Start-UsersCsvUpload -Path $Path

            $ReturnID = $Registration.ReturnID

            if ($null -ne $ReturnID) {

                #Step 2: commit the import using the ReturnID from step 1
                $Result = Submit-UsersCsvUpload -ReturnID $ReturnID -AdminEmail $AdminEmail -SendEmailInvite:$SendEmailInvite -SendSMSInvite:$SendSMSInvite

                [PSCustomObject]@{
                    'Success' = $Result.success
                    'Message' = $Result.Result
                }

            }

        }

    }#process

    END {}#end

}

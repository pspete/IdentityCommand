# .ExternalHelp IdentityCommand-help.xml
# TODO: Only the generic 'Other' template (name,url,username,password,notes,totp,folder columns)
# is supported - importing a provider-native export (LastPass, Dashlane, Google, KeePass, etc.)
# would need that provider's real column layout captured first.
function Import-IDPersonalApplicationCsv {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
        [String]$Path,

        #Confirmed live: the server's "existing" match can be broad enough to skip an entire batch
        #of otherwise-new items, so this defaults to $false rather than the UI's default of $true
        [parameter(Mandatory = $false)]
        [Bool]$SkipIfAppExists = $false,

        [parameter(Mandatory = $false)]
        [Bool]$SkipSharedFolders = $false
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Path, 'Import Personal Applications From CSV')) {

            $Idx = 0
            $CredentialsData = @(foreach ($Row in (Import-Csv -Path $Path)) {

                    $Idx++

                    [ordered]@{
                        'idx'          = $Idx
                        'name'         = $Row.name
                        'username'     = $Row.username
                        'password'     = $Row.password
                        'url'          = $Row.url
                        'notes'        = $Row.notes
                        'isValid'      = $true
                        'symmetricKey' = $null
                        'iv'           = $null
                        'duplicate'    = $false
                        'totp'         = $Row.totp
                        'folder'       = $Row.folder
                    }

                })

            #Step 1: validate the parsed rows
            $Validated = @(Test-PersonalApplicationCsvImport -CredentialsData $CredentialsData)

            #Step 2: commit the import using the validated data. The immediate response doesn't
            #confirm what was actually created - check Get-IDPersonalApplicationImportFile's
            #SuccessRecords/SkippedRecords/FailedRecords for the real outcome
            Submit-PersonalApplicationCsvImport -CredentialsData $Validated -CredFileName (Get-Item -Path $Path).Name -SkipIfAppExists $SkipIfAppExists -SkipSharedFolders $SkipSharedFolders | Out-Null

            [PSCustomObject]@{
                'Success'        = $true
                'SubmittedCount' = $CredentialsData.Count
            }

        }

    }#process

    END {}#end

}

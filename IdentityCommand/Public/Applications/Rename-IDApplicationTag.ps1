# .ExternalHelp IdentityCommand-help.xml
function Rename-IDApplicationTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$TagName,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$NewTagName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($TagName, "Rename Application Tag to '$NewTagName'")) {

            $Body = [ordered]@{
                'newTagname' = $NewTagName
                'tagname'    = $TagName
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/RenameTag"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

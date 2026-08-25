# .ExternalHelp IdentityCommand-help.xml
function Set-IDSecuredItemTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ItemKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$TagName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ItemKey, 'Set Secured Item Tags')) {

            $Body = [ordered]@{
                'tagnames' = @($TagName)
                'sItemkey' = $ItemKey
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpsertTagsForSecuredItem"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

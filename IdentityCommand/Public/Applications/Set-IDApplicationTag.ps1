# .ExternalHelp IdentityCommand-help.xml
function Set-IDApplicationTag {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String[]]$TagName
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Set Application Tags')) {

            $Body = [ordered]@{
                'appkey'   = $AppKey
                'tagnames' = @($TagName)
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpsertTagsForApp"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

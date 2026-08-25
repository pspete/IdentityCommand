# .ExternalHelp IdentityCommand-help.xml
function Set-IDApplicationIcon {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
        [String]$Path
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Upload Personal Application Icon')) {

            $Form = ConvertTo-MultipartFormData -Field @{
                'appkey' = $AppKey
                'Icon'   = (Get-Item -Path $Path)
            }

            $Request = @{

                'URI'         = "$($ISPSSSession.tenant_url)/UPRest/UploadPersonalAppIcon"
                'Method'      = 'POST'
                'Body'        = $Form.Body
                'ContentType' = $Form.ContentType

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

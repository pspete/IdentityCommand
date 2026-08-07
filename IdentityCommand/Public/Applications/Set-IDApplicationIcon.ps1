# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded Bruno sample's body only shows the 'appkey' field with no visible file part,
# but this is an icon upload - it is assumed (by analogy with Set-IDUserPicture) that the image is
# sent as a multipart/form-data file field alongside 'appkey'. The exact field name for the file
# part is unconfirmed - 'Icon' is a best guess.
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

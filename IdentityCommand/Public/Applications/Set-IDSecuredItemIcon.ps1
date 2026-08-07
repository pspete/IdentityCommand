# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded Bruno sample's body only shows the 'sItemkey' field with no visible file part,
# but this is an icon upload - it is assumed (by analogy with Set-IDUserPicture) that the image is
# sent as a multipart/form-data file field alongside 'sItemkey'. The exact field name for the file
# part is unconfirmed - 'Icon' is a best guess.
function Set-IDSecuredItemIcon {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ItemKey,

        [parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
        [String]$Path
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ItemKey, 'Upload Secured Item Icon')) {

            $Form = ConvertTo-MultipartFormData -Field @{
                'sItemkey' = $ItemKey
                'Icon'     = (Get-Item -Path $Path)
            }

            $Request = @{

                'URI'         = "$($ISPSSSession.tenant_url)/UPRest/UploadSecuredItemIcon"
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

# .ExternalHelp IdentityCommand-help.xml
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

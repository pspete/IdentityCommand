# .ExternalHelp IdentityCommand-help.xml
function Set-IDUserPicture {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
        [String]$Path
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Set User Picture')) {

            $Form = ConvertTo-MultipartFormData -Field @{ 'Picture' = (Get-Item -Path $Path) }

            $Request = @{

                'URI'         = "$($ISPSSSession.tenant_url)/CDirectoryService/SetUserPicture?ID=$($ID | Get-EscapedString)"
                'Method'      = 'POST'
                'Body'        = $Form.Body
                'ContentType' = $Form.ContentType

            }

            #Send Request - on success this returns a relative path to fetch the uploaded picture
            #from, rather than the picture data itself. Follow it and return the picture, wrapped
            #with its Content-Type/Length so the raw bytes aren't dumped to the console by default.
            $PicturePath = Invoke-IDRestMethod @Request

            if ($PicturePath) {

                $Bytes = Invoke-IDRestMethod -URI "$($ISPSSSession.tenant_url)$PicturePath" -Method GET

                [PSCustomObject]@{

                    'ContentType' = $ISPSSSession.LastCommandResults.Headers['Content-Type']
                    'Length'      = $Bytes.Length
                    'Bytes'       = $Bytes

                }

            }

        }

    }#process

    END {}#end

}

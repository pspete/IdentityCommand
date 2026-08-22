# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: The full success path (a real image actually being accepted and set) is still
# unconfirmed.
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

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

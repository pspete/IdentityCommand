# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production. Live-tested 2026-08-21 with an undersized test
# image - correctly reached the server and got back a real validation error (image too small),
# confirming the request path works, but the full success path (a real image actually being
# accepted and set) is still unconfirmed. That test also exposed and fixed a real bug in the
# shared Get-IDResponse infra - see its own history/TESTING.md.
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

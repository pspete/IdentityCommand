# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - live-tested against a genuine, existing admin-managed catalog application
# (created via Import-IDApplicationTemplate); UPRest/UploadPersonalAppIcon rejected it with "This
# application is no longer available." "UPRest" = User Portal REST, and a "Personal App" appears
# to be a distinct, separate object type in this API (a self-service app a user bookmarks/adds
# themselves via the User Portal or browser extension - see Update-IDPersonalUserApplication /
# Update-IDCapturedUserApplication) from an admin-managed catalog application. This endpoint may
# simply not apply to -AppKey values from New-IDApplication/Import-IDApplicationTemplate at all.
# Needs either a genuine Personal App's key to retest against, or a DevTools capture of the User
# Portal's "change icon" action on a personal app.
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

# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - no command in this module can enumerate "secured items" to find a real
# -ItemKey to test against (no Get-IDSecuredItem exists), so this has never been live-tested at
# all. The sibling Set-IDApplicationIcon (same UPRest namespace) was live-tested and rejected a
# genuine admin-managed application with "This application is no longer available." - UPRest
# appears to be scoped to "Personal Apps" (a distinct self-service object type - see
# Update-IDPersonalUserApplication), not admin-managed items, so -ItemKey likely has the same scope
# mismatch. Needs a DevTools capture of wherever "secured items" actually come from in the portal
# (what a secured item even is has never been confirmed) before this can be tested at all.
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

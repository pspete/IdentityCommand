# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The recorded Bruno sample's body has no field identifying which secured item to update
# (no itemkey/sItemkey). -ItemKey is added here as an inferred query-string parameter by analogy
# with Get-IDApplicationData's ?appkey= pattern, but this is unconfirmed.
function Update-IDSecuredItemCredential {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ItemKey,

        [parameter(Mandatory = $false)]
        [String]$Username,

        [parameter(Mandatory = $false)]
        [SecureString]$Password,

        [parameter(Mandatory = $false)]
        [String]$CustomFields,

        [parameter(Mandatory = $false)]
        [String]$Notes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ItemKey, 'Update Secured Item Credentials')) {

            $Body = [ordered]@{
                'CustomFields' = $CustomFields
                'Notes'        = $Notes
                'Username'     = $Username
            }

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ($Password | ConvertTo-InsecureString)

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdateCredsForSecuredItem`?itemkey=$($ItemKey | Get-EscapedString)"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

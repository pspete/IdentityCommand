# .ExternalHelp IdentityCommand-help.xml
# TODO: The real expected format for -CustomFields is unconfirmed.
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

            #Only send fields actually supplied - the server rejects an empty string for
            #CustomFields with a type-casting error when it's sent unset
            $Body = $PSBoundParameters | Get-Parameter -ParametersToRemove ItemKey, Password

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ($Password | ConvertTo-InsecureString)

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdateCredsForSecuredItem`?sItemkey=$($ItemKey | Get-EscapedString)"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
# TODO: Confirmed live for -SecuredItemType 'Password' only. Other types (e.g. 'SecureNote', seen
# on existing items via Get-IDSecuredItem) likely need different fields (a note's content, rather
# than -Username/-Password) - unconfirmed.
function New-IDSecuredItem {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$SecuredItemType,

        [parameter(Mandatory = $false)]
        [String]$Description,

        [parameter(Mandatory = $false)]
        [String]$Username,

        [parameter(Mandatory = $false)]
        [SecureString]$Password
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, 'Create Secured Item')) {

            $Body = $PSBoundParameters | Get-Parameter -ParametersToRemove Password

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ($Password | ConvertTo-InsecureString)

            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/AddSecuredItem"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request - on success this returns the new item's UUID as a plain string
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

# .ExternalHelp IdentityCommand-help.xml
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
        [SecureString]$Password,

        [parameter(Mandatory = $false)]
        [String]$Notes
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
                #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of
                #this call records a non-revealing type name instead of the literal request content
                'Body'   = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json))

            }

            #Send Request - on success this returns the new item's UUID as a plain string
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

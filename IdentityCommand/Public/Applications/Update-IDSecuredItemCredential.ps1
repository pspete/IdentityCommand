# .ExternalHelp IdentityCommand-help.xml
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

        #Each entry: @{Key='<name>'; Value='<value>'; Hidden=$true/$false} - Hidden defaults to
        #$false if omitted
        [parameter(Mandatory = $false)]
        [Hashtable[]]$CustomFields,

        [parameter(Mandatory = $false)]
        [String]$Notes
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ItemKey, 'Update Secured Item Credentials')) {

            #Only send fields actually supplied - the server rejects an empty string for
            #CustomFields with a type-casting error when it's sent unset
            $Body = $PSBoundParameters | Get-Parameter -ParametersToRemove ItemKey, Password, CustomFields

            if ($PSBoundParameters.ContainsKey('Password')) {

                $Body['Password'] = ($Password | ConvertTo-InsecureString)

            }

            if ($PSBoundParameters.ContainsKey('CustomFields')) {

                $Body['CustomFields'] = @(foreach ($Field in $CustomFields) {

                        [ordered]@{
                            'CustomFields_Key'      = $Field.Key
                            'CustomFields_Value'    = $Field.Value
                            'CustomFields_IsHidden' = if ($Field.ContainsKey('Hidden')) { [Bool]$Field.Hidden } else { $false }
                        }

                    })

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

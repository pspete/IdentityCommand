# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED - -Grant entries are @{Right='<right>'; Principal='<id>';
# PrincipalType='<type>'} and -Revoke entries are @{Right='<right>'; Principal='<id>'} (no
# PrincipalType), per the vendor's OpenAPI schema. Despite the schema saying Right is a string,
# 'View' was rejected with a server-side type-casting failure, not an invalid-enum error - Right's
# real type/values remain unknown. No UI surface sets this (the portal's org "Roles" tab is a
# different, already-covered concept - see Get-IDOrganizationRole).
function Set-IDOrganizationPermission {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

        [parameter(Mandatory = $false)]
        [Array]$Grant = @(),

        [parameter(Mandatory = $false)]
        [Array]$Revoke = @()
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Update Organization Permissions')) {

            $Body = [ordered]@{
                'Grant'  = $Grant
                'OrgId'  = $ID
                'Revoke' = $Revoke
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/UpdatePermission"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

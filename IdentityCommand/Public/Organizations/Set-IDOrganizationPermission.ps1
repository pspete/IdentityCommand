# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - -Grant expects an array of hashtables like @{Right=@('<right>');
# Principal='<principal>'; PrincipalType='<type>'} ('Right' must itself be an array, even for a
# single right). The actual valid values for 'Right' remain unknown - 'View' was rejected as an
# invalid enum value. Needs a DevTools capture of the admin portal's organization permissions UI,
# or vendor API documentation listing the enum's real members.
function Set-IDOrganizationPermission {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$OrgId,

        [parameter(Mandatory = $false)]
        [Array]$Grant = @(),

        [parameter(Mandatory = $false)]
        [Array]$Revoke = @()
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($OrgId, 'Update Organization Permissions')) {

            $Body = [ordered]@{
                'Grant'  = $Grant
                'OrgId'  = $OrgId
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

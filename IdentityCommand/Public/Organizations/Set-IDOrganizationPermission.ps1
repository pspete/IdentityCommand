# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: DEPRIORITIZED - the outer shape is confirmed live 2026-08-21: -Grant expects an array of
# hashtables like @{Right=@('<right>'); Principal='<principal>'; PrincipalType='<type>'}, and
# 'Right' specifically must itself be an array (even for a single right), not a bare string - a
# bare string failed with "Get value type casting failure. Key:Right. Value:View." (inner
# exception: "Unable to cast object of type 'System.String' to type
# 'System.Collections.Generic.IEnumerable`1[System.Object]'."). But the actual valid values for
# 'Right' remain unknown: 'View' (in an array) failed with "Requested value 'View' was not found"
# (a .NET Enum.Parse failure, confirming Right is a real server-side enum), and the only live
# example found (Get-IDOrganizationPermission on an existing org) showed 'Right: Unknown' - almost
# certainly a default/unset enum member, not a real grantable value. Not being pursued further by
# guessing; next step if revisited is a DevTools capture of the admin portal's organization
# permissions UI, or vendor API documentation listing the enum's real members.
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

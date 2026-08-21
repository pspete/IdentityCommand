# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
# TODO: -Add and -Remove expect arrays of hashtables shaped like the recorded sample, e.g.
# @{ID='<userUUID>'; Type='User'}.
function Set-IDOrganizationMembership {
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
        [Array]$Add = @(),

        [parameter(Mandatory = $false)]
        [Array]$Remove = @()
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($OrgId, 'Update Organization Membership')) {

            $Body = [ordered]@{
                'Add'    = $Add
                'OrgId'  = $OrgId
                'Remove' = $Remove
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/ChangeMembership"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

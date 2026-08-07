# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: -Grant expects an array of hashtables shaped like the recorded sample, e.g.
# @{DirectoryServiceUuid='...'; Id='<userUUID>'; SystemName='<user>'; Type='User'} - -Revoke expects
# an array of hashtables like @{Id='<userUUID>'}.
function Set-IDOrganizationAdministrator {
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

        if ($PSCmdlet.ShouldProcess($OrgId, 'Update Organization Administrators')) {

            $Body = [ordered]@{
                'Grant'  = $Grant
                'OrgId'  = $OrgId
                'Revoke' = $Revoke
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Org/UpdateAdministrators"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

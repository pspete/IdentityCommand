# .ExternalHelp IdentityCommand-help.xml
# TODO: -Revoke's shape is unconfirmed (no revoke request has been tested) - presumed to be an
# array of hashtables like @{Id='<userUUID>'}, matching -Grant's confirmed shape.
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

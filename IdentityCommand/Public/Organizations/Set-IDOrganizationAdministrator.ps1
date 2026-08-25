# .ExternalHelp IdentityCommand-help.xml
function Set-IDOrganizationAdministrator {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID,

        #Array of @{Id='<userUUID>'}
        [parameter(Mandatory = $false)]
        [Array]$Grant = @(),

        #Array of plain user UUID strings - confirmed a different shape to -Grant
        [parameter(Mandatory = $false)]
        [String[]]$Revoke = @()
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Update Organization Administrators')) {

            $Body = [ordered]@{
                'Grant'  = $Grant
                'OrgId'  = $ID
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

# .ExternalHelp IdentityCommand-help.xml
function Get-IDOrganizationPermission {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$OrgId
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/Org/GetPermission"
            'Method' = 'POST'
            'Body'   = (@{ 'OrgId' = $OrgId } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

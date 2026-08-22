# .ExternalHelp IdentityCommand-help.xml
function Get-IDOrganizationAdministrator {
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

            'URI'    = "$($ISPSSSession.tenant_url)/Org/GetAdministrators"
            'Method' = 'POST'
            'Body'   = (@{ 'OrgId' = $OrgId } | ConvertTo-Json)

        }

        #Send Request
        Invoke-IDRestMethod @Request

    }#process

    END {}#end

}

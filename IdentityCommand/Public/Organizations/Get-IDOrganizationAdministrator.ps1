# .ExternalHelp IdentityCommand-help.xml
function Get-IDOrganizationAdministrator {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/Org/GetAdministrators"
            'Method' = 'POST'
            'Body'   = (@{ 'OrgId' = $ID } | ConvertTo-Json)

        }

        #Send Request
        $Result = Invoke-IDRestMethod @Request

        #RedRock-style query envelope (IsAggregate/Count/Columns/Results/...) - flatten to the row data
        if ($null -ne $Result) {

            return $Result.Results.Row

        }

    }#process

    END {}#end

}

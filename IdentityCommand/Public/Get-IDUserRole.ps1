# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserRole {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [int]$Limit,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [int]$PageNumber,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [int]$PageSize,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateRange(-1, 0)]
        [int]$Caching,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$SortBy
    )

    BEGIN {

    }#begin

    PROCESS {

        $URLParameters = $PSBoundParameters | Get-Parameter -ParametersToKeep ID
        $BoundParameters = $PSBoundParameters | Get-Parameter -ParametersToRemove ID

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/GetUsersRolesAndAdministrativeRights?$($URLParameters | ConvertTo-QueryString)"

        $Body = @{'Args' = $BoundParameters } | ConvertTo-Json

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        if ($null -ne $result) {
            $result
        }

    }#process

    END { }#end

}
function Invoke-IDSqlcmd {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$Script,

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
        [bool]$Direction,

        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [string]$SortBy
    )

    BEGIN {

    }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/Redrock/query"

        #Redrock only honors Limit when it's paired with PageNumber/PageSize - default them from
        #Limit when not explicitly supplied, so -Limit alone behaves as callers would expect.
        if ($PSBoundParameters.ContainsKey('Limit')) {

            if (-not $PSBoundParameters.ContainsKey('PageSize')) {

                $PSBoundParameters.Add('PageSize', $Limit)

            }

            if (-not $PSBoundParameters.ContainsKey('PageNumber')) {

                $PSBoundParameters.Add('PageNumber', 1)

            }

        }

        #Create request body with Script & args properties
        $Cmd = $PSBoundParameters | Get-Parameter -ParametersToKeep Script
        $Cmd.Add('args', $($PSBoundParameters | Get-Parameter -ParametersToRemove Script))
        $Body = $Cmd | ConvertTo-Json

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST -Body $Body

        if ($null -ne $result) {
            $result.Results.Row
        }

    }#process

    END { }#end

}

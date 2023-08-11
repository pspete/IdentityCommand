# .ExternalHelp IdentityCommand-help.xml
function Suspend-IDUserMFA {
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
        [Int]$timespan
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$Script:tenant_url/CDirectoryService/ExemptUserFromMfa?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END { }#end

}
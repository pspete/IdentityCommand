# .ExternalHelp IdentityCommand-help.xml
function Clear-IDUserSession {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$id
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$Script:tenant_url/UserMgmt/SignOutEverywhere?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"

        #Send Logoff Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {

    }#end

}
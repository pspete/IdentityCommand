# .ExternalHelp IdentityCommand-help.xml
function Test-IDUserCloudLock {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$Script:tenant_url/UserMgmt/IsUserCloudLocked?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"

        #Send Logoff Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST

        if ($null -ne $result) {
            [bool]$result
        }

    }#process

    END { }#end

}
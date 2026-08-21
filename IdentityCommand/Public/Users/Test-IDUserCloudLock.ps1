# .ExternalHelp IdentityCommand-help.xml
# -ID added as an alias for -user, matching Lock-IDUser/Unlock-IDUser (same underlying parameter
# naming inconsistency, found and fixed via live testing).
function Test-IDUserCloudLock {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid', 'ID')]
        [String]$user
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/IsUserCloudLocked?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"

        #Send Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST

        if ($null -ne $result) {
            [bool]$result
        }

    }#process

    END { }#end

}
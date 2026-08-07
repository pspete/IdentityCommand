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
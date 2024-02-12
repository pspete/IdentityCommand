# .ExternalHelp IdentityCommand-help.xml
function Unlock-IDUser {
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

    BEGIN {
        $Action = @{ 'lockuser' = $false }
    }#begin

    PROCESS {

        $BoundParameters = ($PSBoundParameters | Get-Parameter) + $Action

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/SetCloudLock?$($BoundParameters | ConvertTo-QueryString)"

        #Send Unlock Request
        $result = Invoke-IDRestMethod -Uri $URI -Method POST

        if ($null -ne $result) {
            [bool]$result
        }

    }#process

    END { }#end

}
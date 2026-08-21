# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant. -ID added as an alias for -user, matching the rest of the
# module's convention.
function Lock-IDUser {
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

    BEGIN {
        $Action = @{ 'lockuser' = $true }
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
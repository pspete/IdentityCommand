# .ExternalHelp IdentityCommand-help.xml
function Test-IDUserLockedOutByPolicy {
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

    BEGIN {}#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/IsUserLockedOutByPolicy?user=$($ID | Get-EscapedString)"

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {}#end

}

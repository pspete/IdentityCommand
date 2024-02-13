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
        [String]$ID
    )

    BEGIN { }#begin

    PROCESS {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/SignOutEverywhere?$($PSBoundParameters | Get-Parameter | ConvertTo-QueryString)"

        #Send Logoff Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    END {

    }#end

}
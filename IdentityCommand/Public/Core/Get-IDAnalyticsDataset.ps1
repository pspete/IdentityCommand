# .ExternalHelp IdentityCommand-help.xml
function Get-IDAnalyticsDataset {
    [CmdletBinding()]
    param( )

    BEGIN {

        $URI = "$($ISPSSSession.tenant_url)/analytics/services/v1.0/dataset"

    }#begin

    PROCESS {

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method GET

    }#process

    END {}#end

}
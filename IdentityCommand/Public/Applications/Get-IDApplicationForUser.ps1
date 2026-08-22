# .ExternalHelp IdentityCommand-help.xml
function Get-IDApplicationForUser {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$UserUuid
    )

    BEGIN {}#begin

    PROCESS {

        $Request = @{

            'URI'    = "$($ISPSSSession.tenant_url)/UPRest/GetResultantAppsForUser`?userUuid=$($UserUuid | Get-EscapedString)"
            'Method' = 'POST'

        }

        #Send Request
        $result = Invoke-IDRestMethod @Request

        #GetResultantAppsForUser returns a RedRock-style query envelope (IsAggregate/Count/
        #Columns/Results/...) - flatten to the actual application rows, matching every other
        #RedRock-backed command in this module (fixed live 2026-08-21, was returning the raw
        #wrapper unflattened)
        if ($null -ne $result) {

            $result.Results.Row

        }

    }#process

    END {}#end

}

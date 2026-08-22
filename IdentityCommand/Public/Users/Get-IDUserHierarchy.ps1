# .ExternalHelp IdentityCommand-help.xml
function Get-IDUserHierarchy {
    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = $false,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    begin {}#begin

    process {

        $URI = "$($ISPSSSession.tenant_url)/UserMgmt/GetUserHierarchy"

        if ($PSBoundParameters.ContainsKey('ID')) {

            $URI = "$URI`?ID=$($ID | Get-EscapedString)"

        }

        #Send Request
        Invoke-IDRestMethod -Uri $URI -Method POST

    }#process

    end {}#end

}

# .ExternalHelp IdentityCommand-help.xml
function Update-IDUserApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [String]$Notes,

        [parameter(Mandatory = $false)]
        [ValidateSet('', 'BaseDomain', 'RegularExpression', 'ExactMatch', 'Hostname')]
        [String]$UrlMatchDetection,

        [parameter(Mandatory = $false)]
        [String]$MatchPattern
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Update User Application')) {

            $Body = [ordered]@{ 'appkey' = $AppKey }

            if ($PSBoundParameters.ContainsKey('Notes')) { $Body['notes'] = $Notes }
            if ($PSBoundParameters.ContainsKey('UrlMatchDetection')) { $Body['UrlMatchDetection'] = $UrlMatchDetection }
            if ($PSBoundParameters.ContainsKey('MatchPattern')) { $Body['MatchPattern'] = $MatchPattern }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdateUserApplication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

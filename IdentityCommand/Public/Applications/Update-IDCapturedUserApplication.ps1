# .ExternalHelp IdentityCommand-help.xml
# TODO: DEPRIORITIZED -  server returned success:true but silently made no actual change
# needs a genuine browser-extension-captured app to test properly
function Update-IDCapturedUserApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $false)]
        [String]$AppName,

        [parameter(Mandatory = $false)]
        [String]$AppDescription,

        [parameter(Mandatory = $false)]
        [String]$Notes,

        [parameter(Mandatory = $false)]
        [String]$AppUrl
    )

    begin {}#begin

    process {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Update Captured User Application')) {

            #Only send fields actually supplied - the near-identical Update-IDPersonalUserApplication
            #confirmed live that always sending blank strings for unset optional fields would
            #silently clear existing values
            $Body = [ordered]@{ 'appkey' = $AppKey }

            if ($PSBoundParameters.ContainsKey('AppName')) { $Body['appName'] = $AppName }
            if ($PSBoundParameters.ContainsKey('AppDescription')) { $Body['appDescription'] = $AppDescription }
            if ($PSBoundParameters.ContainsKey('Notes')) { $Body['notes'] = $Notes }
            if ($PSBoundParameters.ContainsKey('AppUrl')) { $Body['appUrl'] = $AppUrl }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdateCapturedUserApplication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    end {}#end

}

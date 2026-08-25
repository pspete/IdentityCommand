# .ExternalHelp IdentityCommand-help.xml
function Update-IDPersonalUserApplication {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$AppKey,

        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$AppName,

        [parameter(Mandatory = $false)]
        [String]$AppDescription,

        [parameter(Mandatory = $false)]
        [String]$Notes,

        [parameter(Mandatory = $false)]
        [String]$AppUrl
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($AppKey, 'Update Personal User Application')) {

            #-AppName is mandatory (confirmed live: rejected with "Application name cannot be
            #blank." when unset) and other fields are only sent when actually supplied, so an
            #omitted -AppDescription/-Notes/-AppUrl doesn't clear an existing value
            $Body = [ordered]@{
                'appkey'  = $AppKey
                'appName' = $AppName
            }

            if ($PSBoundParameters.ContainsKey('AppDescription')) { $Body['appDescription'] = $AppDescription }
            if ($PSBoundParameters.ContainsKey('Notes')) { $Body['notes'] = $Notes }
            if ($PSBoundParameters.ContainsKey('AppUrl')) { $Body['appUrl'] = $AppUrl }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/UPRest/UpdatePersonalApplication"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

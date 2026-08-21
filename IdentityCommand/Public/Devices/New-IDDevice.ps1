# .ExternalHelp IdentityCommand-help.xml
# Verified against a live tenant.
function New-IDDevice {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateSet('Android', 'iOS')]
        [String]$Platform,

        [parameter(Mandatory = $false)]
        [String]$Version,

        [parameter(Mandatory = $false)]
        [String]$Os,

        [parameter(Mandatory = $false)]
        [String]$SimpleName,

        [parameter(Mandatory = $false)]
        [String]$Udid,

        [parameter(Mandatory = $false)]
        [String]$Imei,

        [parameter(Mandatory = $false)]
        [String]$Manufacturer,

        [parameter(Mandatory = $false)]
        [String]$Name
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($Name, "Enroll $Platform Device")) {

            $Body = [ordered]@{
                'Version'      = $Version
                'Os'           = $Os
                'SimpleName'   = $SimpleName
                'Udid'         = $Udid
                'Imei'         = $Imei
                'Manufacturer' = $Manufacturer
                'Name'         = $Name
            }

            $URI = switch ($Platform) {
                'Android' { "$($ISPSSSession.tenant_url)/Device/EnrollAndroidDevice" }
                'iOS' { "$($ISPSSSession.tenant_url)/Device/EnrollIosDevice" }
            }

            $Request = @{

                'URI'    = $URI
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json -Depth 6)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

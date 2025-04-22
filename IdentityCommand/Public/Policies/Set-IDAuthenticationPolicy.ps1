function Set-IDAuthenticationPolicy {

    [CmdletBinding()]
	param
	(
        [Parameter(Mandatory = $true,
        ValueFromPipelinebyPropertyName = $true)]
        $PolicyName,

        [Parameter(Mandatory = $false)]
        $Description = "",

        [Parameter(Mandatory = $false)]
        [ValidateSet('Role','Global','Collection')]
        $LinkType = "Global"
    )

    BEGIN {} #begin

    PROCESS {

        $Plinks = Get-IDAuthenticationPolicyLink

        $PolicyBlock = Get-IDAuthenticationPolicyBlock -Name $PolicyName
        $RevStamp = $PolicyBlock | Select-Object -ExpandProperty RevStamp
        $Version = $PolicyBlock | Select-Object -ExpandProperty Version 
        $Version++

        $Plinks = (ConvertTo-Json -InputObject $Plinks)

        $Body = "{

            'plinks' : $($Plinks),
            'policy':  {

                'Newpolicy': 'false',
                'Version': '$($Version)',
                'Path': '/Policy/$PolicyName',
                'RevStamp': '$($Revstamp)',
                'Settings': {
                    '/Core/Security/CDS/ExternalMFA/ShowQRCode': true
                },
                'Description': '$($Description)'

            }
        }"

        #Constructed parameters for the rest call
        $RestCall = @{

        "URI"         = "https://$($ISPSSSession.TenantId).id.cyberark.cloud/Policy/SavePolicyBlock3"
        "Headers"     = $($ISPSSSession.WebSession.Headers)
        "Method"      = "Post"
        "Body"        = $Body
        "ContentType" = "application/json"

        }
        # invoking the rest call
        $result = Invoke-IDRestMethod @RestCall

        return $result
    } #process

    END {} #end
}

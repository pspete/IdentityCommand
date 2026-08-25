# .ExternalHelp IdentityCommand-help.xml
function New-IDAuthenticationPolicy {

    [CmdletBinding(SupportsShouldProcess)]
	param
	(
        [Parameter(Mandatory = $true)]
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

        if ($PSCmdlet.ShouldProcess($PolicyName, 'Create Authentication Policy')) {

            $NewPolicy = [PSCustomObject]@{
                "Description" = $Description
                "PolicySet" = "/Policy/$PolicyName"
                "LinkType" = $LinkType
                "Priority" = 1
                "Params" = @()
                "Filters" = @()
                "Allowedpolicies" = @()
            }

            $Plinks += $NewPolicy

            $Plinks = (ConvertTo-Json -InputObject $Plinks)

            $Body = "{

                'plinks' : $($Plinks),
                'policy':  {

                    'Newpolicy': 'true',
                    'Version': '1',
                    'Path': '/Policy/$PolicyName',
                    'Settings': {
                        '/Core/Security/CDS/ExternalMFA/ShowQRCode': true
                    },
                    'Description': '$($Description)'

                }
            }"

            #Constructed parameters for the rest call
            $RestCall = @{

            "URI"         = "$($ISPSSSession.tenant_url)/Policy/SavePolicyBlock3"
            "Headers"     = $($ISPSSSession.WebSession.Headers)
            "Method"      = "Post"
            "Body"        = $Body
            "ContentType" = "application/json"

            }
            # invoking the rest call
            $result = Invoke-IDRestMethod @RestCall

            return $result

        }
    } #process

    END {} #end
}

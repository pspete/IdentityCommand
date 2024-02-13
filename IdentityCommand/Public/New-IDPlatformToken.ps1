# .ExternalHelp IdentityCommand-help.xml
Function New-IDPlatformToken {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        #tenant_url
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$tenant_url,

        #User Creds
        [Parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
    )

    Begin {
        #Remove WebSession which may exist in module scope
        $ISPSSSession.WebSession = $null

        $LogonRequest = @{ }
        $LogonRequest['Method'] = 'POST'
        $LogonRequest['SessionVariable'] = 'IDSession'
    }

    Process {

        #Ensure URL is in expected format
        #Remove trailing space if provided in Url
        $tenant_url = $tenant_url -replace '/$', ''

        #Set Module Scope variables
        $ISPSSSession.tenant_url = $tenant_url

        $LogonRequest['Uri'] = "$($ISPSSSession.tenant_url)/OAuth2/PlatformToken"
        $LogonRequest['Headers'] = @{'accept' = '*/*' }
        $LogonRequest['ContentType'] = 'application/x-www-form-urlencoded'
        $LogonRequest['Body'] = @{

            #grant_type=client_credentials is supported for non-interactive API
            grant_type    = 'client_credentials'
            #Add user name from credential object
            client_id     = $($Credential.UserName)
            #Add decoded password value from credential object
            client_secret = $($Credential.GetNetworkCredential().Password)

        }

        if ($PSCmdlet.ShouldProcess($($ISPSSSession.tenant_url), 'Request Platform Token')) {

            #*Get OIDC token based on grant type
            $IDSession = Invoke-IDRestMethod @LogonRequest

            if ($null -ne $IDSession) {

                $result = $IDSession | Add-CustomType -Type IdCmd.ID.PlatformToken

                #Add GetWebSession ScriptMethod
                $result | Add-Member -MemberType ScriptMethod -Name GetWebSession -Value {

                    Get-IDSession | Select-Object -ExpandProperty WebSession

                } -Force

                #Add GetToken ScriptMethod to output Bearer Token
                $result | Add-Member -MemberType ScriptMethod -Name GetToken -Value {

                    Write-Output @{Authorization = "$($this.token_type) $($this.access_token)" }

                } -Force

                #Return the result
                $result


            }
        }

    }

    End {}

}
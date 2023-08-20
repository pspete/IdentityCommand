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
        Remove-Variable -Name WebSession -Scope Script -ErrorAction SilentlyContinue

        $LogonRequest = @{ }
        $LogonRequest['Method'] = 'POST'
        $LogonRequest['SessionVariable'] = 'IDSession'
    }

    Process {

        #Ensure URL is in expected format
        #Remove trailing space if provided in Url
        $tenant_url = $tenant_url -replace '/$', ''

        #Set Module Scope variables
        Set-Variable -Name tenant_url -Value $tenant_url -Scope Script

        $LogonRequest['Uri'] = "$Script:tenant_url/OAuth2/PlatformToken"
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

        if ($PSCmdlet.ShouldProcess($Script:tenant_url, 'Request Platform Token')) {

            #*Get OIDC token based on grant type
            $IDSession = Invoke-IDRestMethod @LogonRequest

            if ($null -ne $IDSession) {

                $IDSession | Add-CustomType -Type IdCmd.ID.PlatformToken

            }
        }

    }

    End {}

}
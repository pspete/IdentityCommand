Function Start-Authentication {

    [CmdletBinding(SupportsShouldProcess)]
    param(
        #user
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$LogonRequest,

        #User Creds
        [Parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential
    )

    process {

        $LogonRequest['Uri'] = "$Script:tenant_url/Security/StartAuthentication"

        $LogonRequest['Body'] = @{

            User    = $($Credential.UserName)
            Version = $Script:Version

        } | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($Script:tenant_url, 'Start Authentication')) {

            try {

                #Perform Start Authentication
                $IDSession = Invoke-IDRestMethod @LogonRequest

                If ($null -ne $IDSession.PodFqdn) {

                    #Redirect URL has been returned
                    #update module scope variables
                    Clear-Variable -Name tenant_url -Scope Script
                    Remove-Variable -Name WebSession -Scope Script
                    Set-Variable -Name tenant_url -Value "https://$($IDSession.PodFqdn)" -Scope Script

                    $LogonRequest['Uri'] = "$Script:tenant_url/Security/StartAuthentication"

                    #Perform Start Authentication with new URL
                    $IDSession = Invoke-IDRestMethod @LogonRequest

                }

                #Output IDSession
                $IDSession

            } catch { throw $PSItem }

        }

    }

}
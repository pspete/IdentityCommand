Function Start-Authentication {
    <#
    .SYNOPSIS
    Starts a user authentication session

    .DESCRIPTION
    Start the user authentication session to authenticate against CyberArk Identity.

    When the user wants to authenticate to CyberArk Identity providing their username.
    If the user exists in CyberArk Identity cloud directory, the server returns an array of security challenges that the user must fulfill to complete the authentication process.

    .PARAMETER LogonRequest
    The LogonRequest created via New-IDSession

    .PARAMETER Credential
    Credential object containing username and password required to authenticate to CyberArk Identity.

    .EXAMPLE
    $LogonRequest | Start-Authentication -Credential $Credential

    Start the authentication process using the specified LogonRequest & Credential object.

    .NOTES
    Pete Maan 2023
    #>

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

        $LogonRequest['Uri'] = "$($ISPSSSession.tenant_url)/Security/StartAuthentication"

        $LogonRequest['Body'] = @{

            User    = $($Credential.UserName)
            Version = $Script:Version

        } | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($($ISPSSSession.tenant_url), 'Start Authentication')) {

            try {

                #Perform Start Authentication
                $IDSession = Invoke-IDRestMethod @LogonRequest

                If ($null -ne $IDSession.PodFqdn) {

                    #Redirect URL has been returned
                    #update module scope variables
                    $ISPSSSession.tenant_url = $null
                    $ISPSSSession.WebSession = $null
                    $ISPSSSession.tenant_url = "https://$($IDSession.PodFqdn)"

                    $LogonRequest['Uri'] = "$($ISPSSSession.tenant_url)/Security/StartAuthentication"

                    #Perform Start Authentication with new URL
                    $IDSession = Invoke-IDRestMethod @LogonRequest

                }

                #Output IDSession
                $IDSession

            } catch { throw $PSItem }

        }

    }

}
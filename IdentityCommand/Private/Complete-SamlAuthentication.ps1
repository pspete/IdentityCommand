Function Complete-SamlAuthentication {
    <#
    .SYNOPSIS
    Completes a saml authentication request

    .DESCRIPTION
    Complete the SAML authentication session against CyberArk Identity.

    This request utilizes the cookies returned after Start-SamlAuthentication.
    The CyberArk ISPSS tenant should respond and set additional cookies that are used for subsequent authentication.

    .PARAMETER LogonRequest
    The LogonRequest created via New-IDSession

    .EXAMPLE
    $LogonRequest | Complete-SamlAuthentication

    Complete the SAML authentication process, started by Start-SamlAuthentication.

    .NOTES
    Pete Maan 2023
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [hashtable]$LogonRequest
    )

    process {

        #Setup request. This command will return html, so supress output/html error detection
        $Script:ExpectHtml = $true
        $LogonRequest['Method'] = 'GET'
        $LogonRequest['Uri'] = "$Script:tenant_url/login"

        if ($PSCmdlet.ShouldProcess($Script:tenant_url, 'Send Assertion')) {

            try {

                #Perform Start Authentication
                $IDSession = Invoke-IDRestMethod @LogonRequest

                #Output IDSession
                $IDSession

            } catch { throw $PSItem }

        }

        $Script:ExpectHtml = $false
        #TODO: Check if sucesful auth or error

    }

}
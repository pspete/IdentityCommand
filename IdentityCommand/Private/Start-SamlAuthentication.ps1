Function Start-SamlAuthentication {
    <#
    .SYNOPSIS
    Starts SAML user authentication

    .DESCRIPTION
    Start SAML user authentication against CyberArk Identity.

    When the user wants to authenticate to CyberArk Identity providing a SAML Response.
    Successful response should contain the following cookies: .ASPXAUTH, antixss, CCSID, podloc, sessdata, userdata
    Returned cookies will be saved in the WebSession object used by the module for future operations.

    .PARAMETER LogonRequest
    The LogonRequest created via New-IDSession

    .PARAMETER SAMLResponse
    Credential object containing username and password required to authenticate to CyberArk Identity.

    .EXAMPLE
    $LogonRequest | Start-SamlAuthentication SAMLResponse $SAMLResponse

    Start the SAML authentication process using the specified SAMLResponse.

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
        [hashtable]$LogonRequest,

        #SAML Assertion
        [Parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$SAMLResponse
    )

    process {

        #Setup request. This command will return html, so supress output/html error detection
        $Script:ExpectHtml = $true
        $LogonRequest['ContentType'] = 'application/x-www-form-urlencoded'
        $LogonRequest['Uri'] = "$Script:tenant_url/my"

        $LogonRequest['Body'] = @{

            SAMLResponse = $SAMLResponse

        }

        if ($PSCmdlet.ShouldProcess($Script:tenant_url, 'Send SAML Assertion')) {

            try {

                #Perform Start Authentication
                $IDSession = Invoke-IDRestMethod @LogonRequest

                #Output IDSession
                $IDSession

            } catch { throw $PSItem }

        }

        $Script:ExpectHtml = $false
        #TODO: Check for expected cookies

    }

}
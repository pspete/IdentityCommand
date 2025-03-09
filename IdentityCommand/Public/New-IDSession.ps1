# .ExternalHelp IdentityCommand-help.xml
Function New-IDSession {

    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingWriteHost', '', Justification = 'Actual legitimate use of Write-Host')]
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
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'Credential'
        )]
        [ValidateNotNullOrEmpty()]
        [PSCredential]$Credential,

        #SAML Assertion
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $false,
            ValueFromPipelinebyPropertyName = $true,
            ParameterSetName = 'SAML'
        )]
        [String]$SAMLResponse

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
        Set-Variable -Name Version -Value '1.0' -Scope Script

        $LogonRequest['Headers'] = @{'accept' = '*/*' }

        #Must be passed in order to get the parameters needed for OOB IdP auth
        $LogonRequest['Headers'].Add('OobIdPAuth', $true)

        switch ($PSCmdlet.ParameterSetName) {

            'Credential' {
                #*Start Authentication
                $IDSession = $LogonRequest | Start-Authentication -Credential $Credential
                break
            }
            'SAML' {
                #*Send SAML Assertion
                $IDSession = $LogonRequest | Start-SamlAuthentication -SAMLResponse $SAMLResponse
                break
            }
        }

        #Set request properties for Next authentication stage.
        $LogonRequest.Remove('SessionVariable')
        $LogonRequest['Headers'].Add('X-IDAP-NATIVE-CLIENT', $true)

        #Set Module Scope variables
        $ISPSSSession.TenantId = $IDSession.TenantId
        $ISPSSSession.SessionId = $IDSession.SessionId
        #? does SessionId need to be available in script scope?

        switch ($PSCmdlet.ParameterSetName) {

            'Credential' {

                #IdpRedirectShortUrl is only included in the response if the OobIdPAuth header is set to true
                if ($IDSession.IdpRedirectShortUrl) {
                    Write-Host @"
You are being redirected to your browser in order to authenticate to your external identity provider.
If your browser does not open, click on the below URL to navigate to your identity provider.

$($IDSession.IdpRedirectShortUrl)
"@
                    #Launches the user's default browser and navigates it to the external identity provider
                    Start-Process $IDSession.IdpRedirectShortUrl

                    $OobAuthStatusRequest = @{ }
                    $OobAuthStatusRequest['Method'] = 'POST'
                    #Undocumented endpoint for checking the IdpLoginSessionId's status. Sniffed out from the ark-sdk-python project
                    $OobAuthStatusRequest['Uri'] = "$tenant_url/Security/OobAuthStatus"
                    #We need the cookies the server provides in the same response it provides the IdpAuth information
                    $OobAuthStatusRequest['WebSession'] = $ISPSSSession.WebSession
                    $OobAuthStatusRequest['Body'] = @{SessionId = $IDSession.IdpLoginSessionId} | ConvertTo-Json

                    $IDSession = Invoke-IDRestMethod @OobAuthStatusRequest

                    while ($IDSession.State -ne 'Success') {
                        Start-Sleep 2

                        $IDSession = Invoke-IDRestMethod @OobAuthStatusRequest
                    }

                    break
                }

                #The MFA Bit - keep a reference to $IDSession for the MFA Package
                $ThisSession = $IDSession
                for ($Challenge = 0; $Challenge -lt $(($ThisSession.Challenges).Count); $Challenge++) {

                    #Iterate through presented challenges
                    if ($($IDSession.Summary) -eq 'NewPackage') {

                        #Initialise loop and $ThisSession if NewPackage Challenges are presented
                        $Challenge = 0
                        $ThisSession = $IDSession
                        if ($null -ne $ThisSession.EventDescription) { Write-Warning -Message $ThisSession.EventDescription }

                    }

                    #Get Current Challenge Mechanisms
                    $Mechanisms = $ThisSession.Challenges[$Challenge] | Select-Object -ExpandProperty Mechanisms

                    #select challenge mechanism
                    $Mechanism = Select-ChallengeMechanism -Mechanisms $Mechanisms

                    try {

                        #answer challenge mechanism
                        $Answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential $Credential

                        #*Advance Authentication
                        $IDSession = $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer $Answer

                    } catch {

                        throw $PSItem

                    }

                    if ($($IDSession.Summary) -eq 'NewPackage') {

                        #New Package Recieved, decrement counter so we go round the loop again to evaluate.
                        $Challenge--

                    }

                }

                break
            }

            'SAML' {
                #*Get Saml ID Token
                $IDSession = $LogonRequest | Complete-SamlAuthentication
                break
            }
        }

        switch ($IDSession.Summary) {

            'NoncommitalSuccess' {
                Write-Host $IDSession.ClientMessage
                break
            }

            default {

                if ($null -ne $IDSession) {

                    $result = $IDSession | Select-Object -Last 1 | Add-CustomType -Type IdCmd.ID.Session

                    #Add GetWebSession ScriptMethod
                    $result | Add-Member -MemberType ScriptMethod -Name GetWebSession -Value {

                        (Get-IDSession).WebSession

                    } -Force

                    #Add GetToken ScriptMethod to output Bearer Token
                    $result | Add-Member -MemberType ScriptMethod -Name GetToken -Value {

                        Write-Output @{Authorization = "Bearer $($this.Token)" }

                    } -Force

                    #Record authenticated User name, Session Start Time & add Authorization header
                    $ISPSSSession.User = $result.User
                    $ISPSSSession.StartTime = Get-Date
                    $ISPSSSession.WebSession.Headers.Add('Authorization', "Bearer $($result.Token)")

                    #Return the result
                    $result

                }

                break

            }

        }

    } #process

    End { } #end

}
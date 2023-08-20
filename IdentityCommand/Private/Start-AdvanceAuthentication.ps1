Function Start-AdvanceAuthentication {
    <#
    .SYNOPSIS
    Advance the state of an authentication session.

    .DESCRIPTION
    Advance the user authentication to authenticate the user against CyberArk Identity.

    Once Start-Authentication is invoked and a user authentication session has been created successfully, Start-AdvanceAuthentication is invoked to further advance the user authentication process.
    If the request to the API is successful, either another challenge mechanism maybe required to be answered, or a logon success will be reported.
    As a response to advance authentication process, an authentication cookie (. ASPXAUTH) would be returned for the user and be saved in the websession object for the current session.

    .PARAMETER LogonRequest
    The LogonRequest created via New-IDSession

    .PARAMETER Mechanism
    The authentication mechanism determined by the user via Select-ChallengeMechanism

    .PARAMETER Answer
    The answer to satisfy the selected challenge mechanism.

    .EXAMPLE
    $LogonRequest | Start-AdvanceAuthentication -Mechanism $Mechanism -Answer $Answer

    Advances the authentication using the specified LogonRequest, Authentication Mechanism & Mechanism Answer.

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

        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $false
        )]
        [ValidateNotNullOrEmpty()]
        [Object]$Mechanism,

        [parameter(
            Mandatory = $false,
            ValueFromPipeline = $false
        )]
        [ValidateNotNullOrEmpty()]
        [Object]$Answer
    )

    Begin {}

    Process {

        $LogonRequest['Uri'] = "$Script:tenant_url/Security/AdvanceAuthentication"

        $Body = @{
            TenantId    = $Script:TenantId
            SessionId   = $Script:SessionId
            MechanismId = $($Mechanism.MechanismId)
        }

        if ($PSCmdlet.ShouldProcess($Script:tenant_url, 'Advance Authentication')) {

            try {

                switch ($Mechanism) {

                    { $($PSItem.AnswerType) -like 'Start*Oob' } {

                        #*Email, SMS, OATH, *OTP, *U2F, *QR, *PF
                        #StartOOB begins the waiting period for MFA approval

                        $Body['Action'] = 'StartOOB'
                        $LogonRequest['Body'] = $Body | ConvertTo-Json

                        try {

                            Invoke-IDRestMethod @LogonRequest

                        } catch { throw $PSItem }

                    }

                    { $($PSItem.Name) -match 'EMAIL|OTP|U2F|QR|PF' } {

                        #Poll for response
                        $Body['Action'] = 'Poll'
                        break
                    }

                    { $($PSItem.Name) -match 'SQ|UP|OATH|SMS|RESET' } {

                        #Provide Answer Directly
                        #*SQ, UP, OATH, SMS, RESET
                        $Body['Action'] = 'Answer'
                        $Body['Answer'] = Unprotect-Answer $Answer
                        break
                    }

                }

                $LogonRequest['Body'] = $Body | ConvertTo-Json

                #Send Answer, or first poll
                $IDSession = Invoke-IDRestMethod @LogonRequest

                while ($IDSession.Summary -match 'OobPending') {

                    #For pending OOB auth requests, poll every 2 seconds

                    Start-Sleep 2

                    $IDSession = Invoke-IDRestMethod @LogonRequest

                }

            } catch {

                #Cleanup Authentication on any error at the Advance Authentication stage
                Clear-AdvanceAuthentication

                throw $PSItem

            }

            $IDSession

        }

    }

    End {

        #Maybe there is a QR Image to clear up
        Remove-Item $(Join-Path $([Environment]::GetEnvironmentVariable('Temp')) "$Script:SessionId.html") -ErrorAction SilentlyContinue

    }

}
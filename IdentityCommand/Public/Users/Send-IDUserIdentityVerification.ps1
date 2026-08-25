# .ExternalHelp IdentityCommand-help.xml
function Send-IDUserIdentityVerification {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [Alias('Uuid')]
        [String]$ID
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ID, 'Send Identity Verification')) {

            #Step 1: start the challenge for this user, listing their enrolled mechanisms
            $Verification = Start-IdentityVerification -ID $ID

            $Mechanisms = @($Verification.ReturnData.Challenges.Mechanisms)

            if ($Mechanisms.Count -eq 0) {

                $PSCmdlet.ThrowTerminatingError(

                    [System.Management.Automation.ErrorRecord]::new(

                        "User '$ID' has no enrolled identity verification mechanisms.",
                        'MechanismNotFound',
                        [System.Management.Automation.ErrorCategory]::ObjectNotFound,
                        $ID

                    )

                )

            }

            #Same interactive picker used to select a mechanism during login. Must be passed via
            #-Mechanisms, not piped - piping an array auto-enumerates it onto the pipeline one
            #element at a time, causing Select-ChallengeMechanism to run once per mechanism (each
            #seeing a count of 1, so no prompt) instead of once with the full list.
            $Mechanism = Select-ChallengeMechanism -Mechanisms $Mechanisms

            #Same answer collection used during login. No credential exists for the target user in
            #this admin-initiated flow, so the UP/SMS password-based answer will be empty - harmless,
            #since those mechanisms aren't relevant to verifying someone else's identity.
            $Answer = Get-MechanismAnswer -Mechanism $Mechanism -Credential ([PSCredential]::Empty)

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/SendIdentityVerification"
                'Method' = 'POST'

            }

            $Body = [ordered]@{
                'UUID'        = $ID
                'TenantId'    = $ISPSSSession.TenantId
                'SessionId'   = $Verification.ReturnData.SessionId
                'MechanismId' = $Mechanism.MechanismId
            }

            #Mirrors Start-AdvanceAuthentication's Action resolution for the login flow
            switch ($Mechanism) {

                { $($PSItem.AnswerType) -like 'Start*Oob' } {

                    #StartOOB begins the waiting period for MFA approval
                    $Body['Action'] = 'StartOOB'
                    #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging
                    #of this call records a non-revealing type name instead of the literal content
                    $Request['Body'] = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json))

                    $null = Invoke-IDRestMethod @Request

                }

                { $($PSItem.Name) -match 'EMAIL|OTP|U2F|QR|PF' } {

                    #Poll for response
                    $Body['Action'] = 'Poll'
                    break

                }

                { $($PSItem.Name) -match 'SQ|UP|OATH|SMS|RESET' } {

                    #Provide Answer Directly
                    $Body['Action'] = 'Answer'
                    $Body['Answer'] = Unprotect-Answer $Answer
                    break

                }

            }

            #Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of this
            #call records a non-revealing type name instead of the literal request content
            $Request['Body'] = [System.Text.Encoding]::UTF8.GetBytes($($Body | ConvertTo-Json))

            $Result = Invoke-IDRestMethod @Request

            while ($Result.Summary -match 'OobPending') {

                #Polls every second while the challenge is pending
                Start-Sleep 1

                $Result = Invoke-IDRestMethod @Request

            }

            $Result

        }

    }#process

    END {}#end

}

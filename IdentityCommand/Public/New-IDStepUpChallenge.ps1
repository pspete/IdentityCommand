# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: This flow's exact call order is genuinely unclear from the recorded sample requests - the
# 'Get Challenge State' sample (here treated as the answer-submission call, since its body actually
# submits an Answer despite the name) and 'Start Step-up Challenge' samples reference each other's
# outputs (a ChallengeStateId / ChallengeId) in a way that doesn't cleanly resolve to a single
# linear order. This command's best-effort interpretation: StartChallenge begins the flow and
# returns Challenges/Mechanisms (matching the credential auth flow's shape), then ChallengeUser
# answers the selected mechanism. Only the first challenge/mechanism is handled - no multi-factor
# loop or OOB polling support. The 'profileName' query parameter on the answer call is guessed as
# the mechanism's Name (e.g. 'SQ') - unconfirmed. This requires an existing authenticated session
# ($ISPSSSession.TenantId/.SessionId), unlike New-IDUsernameReminder which is a pre-auth flow.
function New-IDStepUpChallenge {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$ChallengeStateId
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Start Step-up Challenge')) {

            $StartBody = [ordered]@{ 'Version' = '1.0' }

            if ($PSBoundParameters.ContainsKey('ChallengeStateId')) {

                $StartBody['ChallengeStateId'] = $ChallengeStateId

            }

            $StartRequest = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Security/StartChallenge"
                'Method' = 'POST'
                'Body'   = ($StartBody | ConvertTo-Json)

            }

            $Challenge = Invoke-IDRestMethod @StartRequest

            if ($Challenge.Challenges.Count -gt 0) {

                $Mechanism = $Challenge.Challenges[0].Mechanisms | Select-ChallengeMechanism
                $Answer = $Mechanism | Get-MechanismAnswer -Credential ([PSCredential]::Empty)

                $AnswerBody = @{
                    'TenantId'    = $ISPSSSession.TenantId
                    'SessionId'   = $ISPSSSession.SessionId
                    'MechanismId' = $Mechanism.MechanismId
                    'Action'      = 'Answer'
                    'Answer'      = Unprotect-Answer $Answer
                }

                $AnswerRequest = @{

                    'URI'    = "$($ISPSSSession.tenant_url)/Security/ChallengeUser?profileName=$($Mechanism.Name | Get-EscapedString)"
                    'Method' = 'POST'
                    'Body'   = ($AnswerBody | ConvertTo-Json)

                }

                Invoke-IDRestMethod @AnswerRequest

            } else {

                $Challenge

            }

        }

    }#process

    END {}#end

}

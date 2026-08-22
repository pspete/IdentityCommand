# .ExternalHelp IdentityCommand-help.xml
# TODO: -RawRegisterResponse must be a genuine browser WebAuthn ceremony result (the JSON-stringified
# response from navigator.credentials.create(), answering the challenge from
# Get-IDUserU2FRegistrationChallenge) - this can't be produced by PowerShell alone, since it requires
# real interaction with a physical/platform authenticator inside a browser. This command only submits
# an already-obtained response.
function Complete-IDUserU2FRegistrationChallenge {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$RawRegisterResponse
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.User, 'Complete U2F Device Registration')) {

            $Body = @{
                'rawRegisterResponse' = $RawRegisterResponse
            }

            $Request = @{

                'URI'    = "$($ISPSSSession.tenant_url)/U2f/AnswerRegistrationChallenge"
                'Method' = 'POST'
                'Body'   = ($Body | ConvertTo-Json)

            }

            #Send Request
            Invoke-IDRestMethod @Request

        }

    }#process

    END {}#end

}

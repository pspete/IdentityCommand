# .ExternalHelp IdentityCommand-help.xml
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

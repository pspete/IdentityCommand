# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The -Interactive path only answers the first challenge/mechanism returned - unlike the
# credential authentication flow's Start-AdvanceAuthentication, it does not loop through multiple
# challenge levels or support OOB-style polling (push notification/email link). The recorded sample
# request only showed a single challenge level for this flow, but that may not hold for every
# tenant's configured policy.
function New-IDUsernameReminder {
    [System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', 'Interactive', Justification = 'Used only to select the ParameterSetName')]
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'SearchKey')]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipelinebyPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [String]$tenant_url,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'SearchKey'
        )]
        [ValidateNotNullOrEmpty()]
        [String]$SearchKey,

        [parameter(
            Mandatory = $true,
            ParameterSetName = 'Interactive'
        )]
        [Switch]$Interactive
    )

    BEGIN {
        #Remove trailing slash if provided in Url
        $tenant_url = $tenant_url -replace '/$', ''
    }#begin

    PROCESS {

        switch ($PSCmdlet.ParameterSetName) {

            'SearchKey' {

                #One-shot lookup: the API sends the reminder directly, no challenge required
                if ($PSCmdlet.ShouldProcess($SearchKey, 'Request Username Reminder')) {

                    $Request = @{

                        'URI'    = "$tenant_url/Security/ForgotUsername"
                        'Method' = 'POST'
                        'Body'   = (@{ 'SearchKey' = $SearchKey } | ConvertTo-Json)

                    }

                    Invoke-IDRestMethod @Request

                }

            }

            'Interactive' {

                if ($PSCmdlet.ShouldProcess($tenant_url, 'Start Interactive Username Reminder Session')) {

                    $IDSession = Start-ForgotUsernameSession -TenantUrl $tenant_url

                    $Mechanism = $IDSession.Challenges[0].Mechanisms | Select-ChallengeMechanism
                    $Answer = $Mechanism | Get-MechanismAnswer -Credential ([PSCredential]::Empty)

                    Complete-ForgotUsernameSession -TenantUrl $tenant_url -TenantId $IDSession.TenantId -SessionId $IDSession.SessionId -Mechanism $Mechanism -Answer $Answer

                }

            }

        }

    }#process

    END {}#end

}

function Start-ForgotUsernameSession {
	<#
	.SYNOPSIS
	Starts a session-based (challenge-gated) forgot-username flow (step 1 of 2).

	.DESCRIPTION
	Calls /Security/ForgotUsername with a Version-only body to begin a challenge-based
	username-lookup session, returning a SessionId and Challenges/Mechanisms array in the same
	shape as the credential authentication flow's Start-Authentication response.
	Deliberately takes -TenantUrl as an explicit parameter rather than reading $ISPSSSession.tenant_url
	- the caller isn't logged in yet when requesting a username reminder, so this keeps the flow
	fully self-contained rather than reading/writing module-scope session state that may belong to
	an unrelated, already-authenticated session.
	Not exported - called internally by the public New-IDUsernameReminder command.

	.PARAMETER TenantUrl
	The base URL of the Identity tenant to start the session against.

	.EXAMPLE
	Start-ForgotUsernameSession -TenantUrl 'https://example.id.cyberark.cloud'
	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$TenantUrl
	)

	Process {

		if ($PSCmdlet.ShouldProcess($TenantUrl, 'Start Forgot Username Session')) {

			$Request = @{

				'URI'    = "$TenantUrl/Security/ForgotUsername"
				'Method' = 'POST'
				'Body'   = (@{ 'Version' = '1.0' } | ConvertTo-Json)

			}

			Invoke-IDRestMethod @Request

		}

	}

}

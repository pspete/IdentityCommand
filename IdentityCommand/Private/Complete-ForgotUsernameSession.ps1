function Complete-ForgotUsernameSession {
	<#
	.SYNOPSIS
	Answers a challenge mechanism for an in-progress forgot-username session (step 2 of 2).

	.DESCRIPTION
	Calls /Security/AdvanceForgotUsername to answer a challenge mechanism, advancing a
	forgot-username session started via Start-ForgotUsernameSession.
	Takes -TenantUrl/-TenantId explicitly rather than reading $ISPSSSession - see
	Start-ForgotUsernameSession for why.
	Not exported - called internally by the public New-IDUsernameReminder command.

	.PARAMETER TenantUrl
	The base URL of the Identity tenant.

	.PARAMETER TenantId
	The short tenant ID, as returned in Start-ForgotUsernameSession's response.

	.PARAMETER SessionId
	The SessionId returned by Start-ForgotUsernameSession.

	.PARAMETER Mechanism
	The mechanism to answer, as selected via Select-ChallengeMechanism.

	.PARAMETER Answer
	The answer to satisfy the selected challenge mechanism, as obtained via Get-MechanismAnswer.

	.EXAMPLE
	Complete-ForgotUsernameSession -TenantUrl $TenantUrl -TenantId $TenantId -SessionId $SessionId -Mechanism $Mechanism -Answer $Answer
	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$TenantUrl,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$TenantId,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$SessionId,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[Object]$Mechanism,

		[Parameter(Mandatory = $false)]
		[Object]$Answer
	)

	Process {

		if ($PSCmdlet.ShouldProcess($TenantUrl, 'Advance Forgot Username Session')) {

			$Body = @{
				'TenantId'        = $TenantId
				'SessionId'       = $SessionId
				'MechanismId'     = $Mechanism.MechanismId
				'Action'          = 'Answer'
				'PersistentLogin' = 'false'
				'Answer'          = Unprotect-Answer $Answer
			}

			$Request = @{

				'URI'    = "$TenantUrl/Security/AdvanceForgotUsername"
				'Method' = 'POST'
				'Body'   = ($Body | ConvertTo-Json)

			}

			Invoke-IDRestMethod @Request

		}

	}

}

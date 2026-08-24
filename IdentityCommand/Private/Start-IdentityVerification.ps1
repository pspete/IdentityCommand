function Start-IdentityVerification {
	<#
	.SYNOPSIS
	Starts an admin-initiated identity verification challenge for a user (step 1 of 2).

	.DESCRIPTION
	Calls /CDirectoryService/StartAuthentication with just a target user's UUID (no credentials),
	returning the same Challenges[].Mechanisms[]/SessionId shape the interactive login flow uses,
	but scoped to that user rather than the caller.
	Not exported - called internally by the public Send-IDUserIdentityVerification command.

	.PARAMETER ID
	The unique ID of the user to start an identity verification challenge for.

	.EXAMPLE
	Start-IdentityVerification -ID 'a1b2c3d4-0000-0000-0000-000000000000'
	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$ID
	)

	Process {

		if ($PSCmdlet.ShouldProcess($ID, 'Start Identity Verification')) {

			$Request = @{

				'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/StartAuthentication"
				'Method' = 'POST'
				'Body'   = (@{ 'UUID' = $ID } | ConvertTo-Json)

			}

			Invoke-IDRestMethod @Request

		}

	}

}

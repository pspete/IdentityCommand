function Submit-UsersCsvUpload {
	<#
	.SYNOPSIS
	Commits a previously registered CSV bulk user import (step 2 of 2).

	.DESCRIPTION
	Calls /CDirectoryService/SubmitUploadedFile to advance/complete a bulk user import previously
	registered via Start-UsersCsvUpload.
	Not exported - called internally by the public Import-IDUserCsv command.

	.PARAMETER ReturnID
	The ReturnID returned by Start-UsersCsvUpload.

	.PARAMETER AdminEmail
	The email address to notify of the import's outcome.

	.PARAMETER SendEmailInvite
	Whether to send an email invite to each imported user.

	.PARAMETER SendSMSInvite
	Whether to send an SMS invite to each imported user.

	.EXAMPLE
	Submit-UsersCsvUpload -ReturnID $ReturnID -AdminEmail 'admin@example.com' -SendEmailInvite
	#>
	[CmdletBinding()]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '', Justification = 'Deliberately falls back to the raw string if it is not JSON')]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$ReturnID,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$AdminEmail,

		[Parameter(Mandatory = $false)]
		[Switch]$SendEmailInvite,

		[Parameter(Mandatory = $false)]
		[Switch]$SendSMSInvite
	)

	Process {

		$Body = [ordered]@{
			'ReturnID'        = $ReturnID
			'AdminEmail'      = $AdminEmail
			'SendSmsInvite'   = [Bool]$SendSMSInvite
			'SendEmailInvite' = [Bool]$SendEmailInvite
		}

		$Request = @{

			'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/SubmitUploadedFile?importType=ImportBulkUser"
			'Method' = 'POST'
			'Body'   = ($Body | ConvertTo-Json)

		}

		$Result = Invoke-IDRestMethod @Request

		#Confirmed live: Result is itself a JSON-encoded string containing a second, identically-
		#shaped envelope - unwrap it so the caller sees a normal object instead of raw JSON text
		if ($Result -is [String]) {

			try { $Result = $Result | ConvertFrom-Json } catch {}

		}

		$Result

	}

}

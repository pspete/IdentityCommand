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
			'AdminEmail'      = $AdminEmail
			'ReturnID'        = $ReturnID
			'SendEmailInvite' = [Bool]$SendEmailInvite
			'SendSMSInvite'   = [Bool]$SendSMSInvite
		}

		$Request = @{

			'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/SubmitUploadedFile?importType=ImportBulkUser"
			'Method' = 'POST'
			'Body'   = ($Body | ConvertTo-Json)

		}

		Invoke-IDRestMethod @Request

	}

}

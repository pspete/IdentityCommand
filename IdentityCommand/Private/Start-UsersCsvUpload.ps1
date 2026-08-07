function Start-UsersCsvUpload {
	<#
	.SYNOPSIS
	Registers a CSV file for bulk user import (step 1 of 2).

	.DESCRIPTION
	Calls /CDirectoryService/GetUsersFromCsvFile to register the default field values to apply to a
	named, already-uploaded CSV file, returning a ReturnID which must be passed to
	Submit-UsersCsvUpload to complete the import.
	Not exported - called internally by the public Import-IDUserCsv command.

	.PARAMETER FileName
	The name of the previously uploaded CSV file.

	.PARAMETER Settings
	A hashtable of default field values (e.g. InEverybodyRole, PasswordNeverExpire) to apply to
	users imported from the file where the CSV itself does not specify a value.

	.EXAMPLE
	Start-UsersCsvUpload -FileName 'users.csv' -Settings @{ SendEmailInvite = $true }
	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$FileName,

		[Parameter(Mandatory = $false)]
		[Hashtable]$Settings = @{}
	)

	Process {

		if ($PSCmdlet.ShouldProcess($FileName, 'Register CSV File For Bulk User Import')) {

			$Body = [ordered]@{
				'FileName' = $FileName
			}
			$Body[$FileName] = $Settings

			$Request = @{

				'URI'    = "$($ISPSSSession.tenant_url)/CDirectoryService/GetUsersFromCsvFile?importType=ImportBulkUser"
				'Method' = 'POST'
				'Body'   = ($Body | ConvertTo-Json -Depth 6)

			}

			Invoke-IDRestMethod @Request

		}

	}

}

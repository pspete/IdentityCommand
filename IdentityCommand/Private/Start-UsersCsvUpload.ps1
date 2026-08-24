function Start-UsersCsvUpload {
	<#
	.SYNOPSIS
	Uploads a CSV file for bulk user import (step 1 of 2).

	.DESCRIPTION
	Calls /CDirectoryService/GetUsersFromCsvFile as a multipart file upload, returning a preview of
	the parsed rows and a ReturnID which must be passed to Submit-UsersCsvUpload to complete the
	import.
	Not exported - called internally by the public Import-IDUserCsv command.

	.PARAMETER Path
	Path to the local CSV file to upload.

	.EXAMPLE
	Start-UsersCsvUpload -Path .\users.csv
	#>
	[CmdletBinding(SupportsShouldProcess)]
	param(
		[Parameter(Mandatory = $true)]
		[ValidateScript({ Test-Path -Path $PSItem -PathType Leaf })]
		[String]$Path
	)

	Process {

		$File = Get-Item -Path $Path

		if ($PSCmdlet.ShouldProcess($File.Name, 'Upload CSV File For Bulk User Import')) {

			#Confirmed live: a multipart upload with the file itself under the 'Icon' field name
			#(reused from a generic upload component elsewhere in the product) alongside the plain
			#'FileName' field
			$Form = ConvertTo-MultipartFormData -Field @{
				'FileName' = $File.Name
				'Icon'     = $File
			}

			$Request = @{

				'URI'         = "$($ISPSSSession.tenant_url)/CDirectoryService/GetUsersFromCsvFile?importType=ImportBulkUser"
				'Method'      = 'POST'
				'Body'        = $Form.Body
				'ContentType' = $Form.ContentType

			}

			Invoke-IDRestMethod @Request

		}

	}

}

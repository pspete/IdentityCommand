function Test-PersonalApplicationCsvImport {
	<#
	.SYNOPSIS
	Validates a batch of personal application credentials for import (step 1 of 2).

	.DESCRIPTION
	Calls /uprest/ValidateImportAccounts, returning the validated credentials data to pass to
	Submit-PersonalApplicationCsvImport.
	Not exported - called internally by the public Import-IDPersonalApplicationCsv command.

	.PARAMETER CredentialsData
	An array of hashtables, one per personal application to import.

	.EXAMPLE
	Test-PersonalApplicationCsvImport -CredentialsData $CredentialsData
	#>
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)]
		[Array]$CredentialsData
	)

	Process {

		$Request = @{

			'URI'    = "$($ISPSSSession.tenant_url)/uprest/ValidateImportAccounts"
			'Method' = 'POST'
			#Sent as raw UTF8 bytes rather than a String so ParameterBinding/module logging of this
			#call records a non-revealing type name instead of the literal request content
			'Body'   = [System.Text.Encoding]::UTF8.GetBytes($(@{ 'credentialsData' = $CredentialsData } | ConvertTo-Json -Depth 6))

		}

		Invoke-IDRestMethod @Request

	}

}

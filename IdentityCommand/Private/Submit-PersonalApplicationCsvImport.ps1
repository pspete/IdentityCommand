function Submit-PersonalApplicationCsvImport {
	<#
	.SYNOPSIS
	Commits a validated batch of personal application credentials for import (step 2 of 2).

	.DESCRIPTION
	Calls /uprest/ImportUserCredentials to commit a personal application import previously
	validated via Test-PersonalApplicationCsvImport.
	Not exported - called internally by the public Import-IDPersonalApplicationCsv command.

	.PARAMETER CredentialsData
	The validated credentials data returned by Test-PersonalApplicationCsvImport.

	.PARAMETER CredFileName
	The name of the source CSV file.

	.PARAMETER CredentialProvider
	The source format the CSV was exported from. Only 'Other' (the generic template) is confirmed.

	.PARAMETER SkipIfAppExists
	Whether to skip an item if a matching app already exists. Confirmed live: a server-side
	"existing" match can be broad enough to skip an entire batch of otherwise-new items, so this
	defaults to $false rather than the UI's default of $true.

	.PARAMETER SkipSharedFolders
	Whether to skip shared folders.

	.EXAMPLE
	Submit-PersonalApplicationCsvImport -CredentialsData $Validated -CredFileName 'export.csv'
	#>
	[CmdletBinding()]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'CredFileName', Justification = 'A file name, not a credential')]
	[System.Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPlainTextForPassword', 'CredentialProvider', Justification = 'A provider name string, not a credential')]
	param(
		[Parameter(Mandatory = $true)]
		[Array]$CredentialsData,

		[Parameter(Mandatory = $true)]
		[ValidateNotNullOrEmpty()]
		[String]$CredFileName,

		[Parameter(Mandatory = $false)]
		[ValidateNotNullOrEmpty()]
		[String]$CredentialProvider = 'Other',

		[Parameter(Mandatory = $false)]
		[Bool]$SkipIfAppExists = $false,

		[Parameter(Mandatory = $false)]
		[Bool]$SkipSharedFolders = $false
	)

	Process {

		$Body = [ordered]@{
			'credentialProvider' = $CredentialProvider
			'credFileName'       = $CredFileName
			'credentialsData'    = $CredentialsData
			'skipIfAppExists'    = $SkipIfAppExists
			'skipSharedFolders'  = $SkipSharedFolders
		}

		$Request = @{

			'URI'    = "$($ISPSSSession.tenant_url)/uprest/ImportUserCredentials"
			'Method' = 'POST'
			'Body'   = ($Body | ConvertTo-Json -Depth 6)

		}

		Invoke-IDRestMethod @Request

	}

}

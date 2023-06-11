function Unprotect-Answer {
	<#
	.SYNOPSIS
	Converts securestrings collected to satisfy authentication challenges to plain text

	.DESCRIPTION
	During the authetication process, any input from the user is protected as a securestring value.
	To send these to the API in a format in which they can be read, they must be converted tfrom the secure string value.
	This command allows this conversion to happen.

	.PARAMETER SecureString
	A SecureString value to convert

	.PARAMETER Hashtable
	A hashtable, containing securestring values to convert

	.EXAMPLE
	Unprotect-Answer $Answer

	Converts the securestring value contained in the $Answer variable

	.NOTES
	Pete Maan 2023
	#>

	[CmdLetBinding()]
	Param (

		[Parameter(
			Mandatory = $True,
			ValueFromPipeline = $False,
			Position = 0,
			ParameterSetName = 'SecureString'
		)]
		[System.Security.SecureString]$SecureString,

		[Parameter(
			Mandatory = $True,
			ValueFromPipeline = $False,
			Position = 0,
			ParameterSetName = 'Hashtable'
		)]
		[hashtable]$Hashtable
	)

	Begin {}

	Process {

		switch ($PSCmdlet.ParameterSetName) {

			'SecureString' {

				ConvertTo-InsecureString -SecureString $SecureString

			}

			'Hashtable' {

				foreach ($key in @($Hashtable.keys)) {

					$Hashtable[$key] = ConvertTo-InsecureString -SecureString $Hashtable[$key]

				}

				$Hashtable

			}

		}

	}

	End {}

}
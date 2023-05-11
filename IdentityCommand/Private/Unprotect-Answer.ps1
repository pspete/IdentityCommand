function Unprotect-Answer {
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
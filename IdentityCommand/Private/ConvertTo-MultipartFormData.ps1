function ConvertTo-MultipartFormData {
	<#
	.SYNOPSIS
	Builds a multipart/form-data request body, including file uploads.

	.DESCRIPTION
	Constructs a raw multipart/form-data byte payload and boundary marker, for use as the Body of an
	Invoke-IDRestMethod call together with an explicit -ContentType of the returned value.
	Implemented without Invoke-WebRequest's -Form parameter, which is PowerShell Core (6+) only,
	so this works on both Windows PowerShell 5.1 and PowerShell Core.

	.PARAMETER Field
	A hashtable of form field names to values. Values that are a FileSystemInfo object (e.g. from
	Get-Item) are sent as file parts; all other values are sent as plain text fields.

	.PARAMETER Boundary
	The multipart boundary string to use. A random one is generated if not supplied.

	.EXAMPLE
	$Form = ConvertTo-MultipartFormData -Field @{ Picture = (Get-Item .\photo.jpg) }
	Invoke-IDRestMethod -Uri $URI -Method POST -Body $Form.Body -ContentType $Form.ContentType

	.OUTPUTS
	PSCustomObject with 'Body' (byte[]) and 'ContentType' (string, including the boundary) properties.
	#>
	[CmdletBinding()]
	[OutputType('System.Management.Automation.PSObject')]
	param(
		[Parameter(Mandatory = $true)]
		[Hashtable]$Field,

		[Parameter(Mandatory = $false)]
		[String]$Boundary = [System.Guid]::NewGuid().ToString()
	)

	Process {

		$LF = "`r`n"
		$Stream = [System.IO.MemoryStream]::new()

		foreach ($Key in $Field.Keys) {

			$Value = $Field[$Key]

			$Bytes = [System.Text.Encoding]::UTF8.GetBytes("--$Boundary$LF")
			$Stream.Write($Bytes, 0, $Bytes.Length)

			if ($Value -is [System.IO.FileSystemInfo]) {

				$Header = "Content-Disposition: form-data; name=`"$Key`"; filename=`"$($Value.Name)`"$LF" +
				"Content-Type: application/octet-stream$LF$LF"
				$Bytes = [System.Text.Encoding]::UTF8.GetBytes($Header)
				$Stream.Write($Bytes, 0, $Bytes.Length)

				$FileBytes = [System.IO.File]::ReadAllBytes($Value.FullName)
				$Stream.Write($FileBytes, 0, $FileBytes.Length)

			} else {

				$Header = "Content-Disposition: form-data; name=`"$Key`"$LF$LF"
				$Bytes = [System.Text.Encoding]::UTF8.GetBytes($Header)
				$Stream.Write($Bytes, 0, $Bytes.Length)

				$Bytes = [System.Text.Encoding]::UTF8.GetBytes([String]$Value)
				$Stream.Write($Bytes, 0, $Bytes.Length)

			}

			$Bytes = [System.Text.Encoding]::UTF8.GetBytes($LF)
			$Stream.Write($Bytes, 0, $Bytes.Length)

		}

		$Bytes = [System.Text.Encoding]::UTF8.GetBytes("--$Boundary--$LF")
		$Stream.Write($Bytes, 0, $Bytes.Length)

		[PSCustomObject]@{
			'Body'        = $Stream.ToArray()
			'ContentType' = "multipart/form-data; boundary=$Boundary"
		}

	}

}

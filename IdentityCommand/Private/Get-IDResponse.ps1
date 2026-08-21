function Get-IDResponse {
	<#
	.SYNOPSIS
	Receives and returns the content of the web response from the CyberArk Identity API

	.DESCRIPTION
	Accepts a WebResponseObject.
	By default returns the Content property passed in the output of Invoke-IDRestMethod.
	Processes the API response as required depending on the format of the response, and
	the format required by the functions which initiated the request.

	.PARAMETER APIResponse
	A WebResponseObject, as returned from the Identity API using Invoke-WebRequest

	.EXAMPLE
	$WebResponseObject | Get-IDResponse

	Parses, if required, and returns, the required properties of $WebResponseObject

	#>
	[CmdletBinding()]
	[OutputType('System.Object')]
	param(
		[parameter(
			Position = 0,
			Mandatory = $true,
			ValueFromPipeline = $true)]
		[ValidateNotNullOrEmpty()]
		[Microsoft.PowerShell.Commands.WebResponseObject]$APIResponse

	)

	BEGIN {	}#begin

	PROCESS {

		if ($APIResponse.Content) {

			#Default Response - Return Content
			$IDResponse = $APIResponse.Content

			#get response content type
			$ContentType = $APIResponse.Headers['Content-Type']

			#handle content type
			switch ($ContentType) {

				{ $PSItem -match 'text/html' } {

					If ($IDResponse -match '<HTML>') {

						If ($Script:ExpectHtml) {
							#HTML output expected, null the html result
							$IDResponse = $null

						}

						Else {

							#Fail if HTML received from request to API

							$PSCmdlet.ThrowTerminatingError(

								[System.Management.Automation.ErrorRecord]::new(

									'Unexpected HTML Response Received. Check the URL provided for your Identity Portal.',
									$StatusCode,
									[System.Management.Automation.ErrorCategory]::NotSpecified,
									$APIResponse

								)

							)

						}

					}

				}

				{ $PSItem -match 'json' } {

					#json content expected (covers application/json as well as SCIM's
					#application/scim+json and similar +json content types)

					#Invoke-WebRequest only auto-decodes recognized text content types to a string;
					#unrecognized ones (e.g. application/scim+json) come back as a raw byte[] - decode
					#it to a string ourselves before parsing
					If ($APIResponse.Content -is [Byte[]]) {

						$RawContent = [System.Text.Encoding]::UTF8.GetString($APIResponse.Content)

					} Else {

						$RawContent = $APIResponse.Content

					}

					#Create Return Object from Returned JSON
					$IDResponse = ConvertFrom-Json -InputObject $RawContent

					switch ($IDResponse) {

						({ $PSItem.success -eq $false }) {

							#if success property is false, throw error
							$ErrorMessage = $IDResponse.Message
							$ErrorID = $IDResponse.ErrorID

							$PSCmdlet.ThrowTerminatingError(

								[System.Management.Automation.ErrorRecord]::new(

									$ErrorMessage,
									$ErrorID,
									[System.Management.Automation.ErrorCategory]::NotSpecified,
									$IDResponse

								)

							)

							break

						}

						({ $PSItem.success -eq $true }) {

							#when success property is returned, return result
							$IDResponse = $IDResponse.Result
							break

						}

					}

				}

			}

			#Return IDResponse
			$IDResponse

		}

	}#process

	END {	}#end

}
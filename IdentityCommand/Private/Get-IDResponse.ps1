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

				{ $PSItem -match 'application/json' } {

					#application/json content expected
					#Create Return Object from Returned JSON
					$IDResponse = ConvertFrom-Json -InputObject $APIResponse.Content

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
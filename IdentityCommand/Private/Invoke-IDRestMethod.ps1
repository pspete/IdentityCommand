﻿function Invoke-IDRestMethod {
	<#
	.SYNOPSIS
	Wrapper for Invoke-WebRequest to call REST method via API

	.DESCRIPTION
	Sends requests to web services. Catches Exceptions. Outputs Success.
	Acts as wrapper for the Invoke-WebRequest CmdLet so that status codes can be
	queried and acted on.
	All requests are sent with ContentType=application/json.
	If the sessionVariable parameter is passed, the function will return the WebSession
	object to the $ISPSSSession.WebSession variable.

	.PARAMETER Method
	The method for the REST Method.
	Only accepts GET, POST, PUT, PATCH or DELETE

	.PARAMETER URI
	The address of the API or service to send the request to.

	.PARAMETER Body
	The body of the request to send to the API

	.PARAMETER Headers
	The header of the request to send to the API.

	.PARAMETER SessionVariable
	If passed, will be sent to invoke-webrequest which in turn will create a websession
	variable using the string value as the name. This variable will only exist in the current scope
	so will be set as the value of $ISPSSSession.WebSession to be available in a modules scope.
	Cannot be specified with WebSession

	.PARAMETER WebSession
	Accepts a WebRequestSession object containing session details
	Cannot be specified with SessionVariable

	.PARAMETER UseDefaultCredentials
	See Invoke-WebRequest
	Used for Integrated Auth

	.PARAMETER Credential
	See Invoke-WebRequest
	Used for Integrated Auth

	.PARAMETER TimeoutSec
	See Invoke-WebRequest
	Specify a timeout value in seconds

	.PARAMETER Certificate
	See Invoke-WebRequest
	The client certificate used for a secure web request.

	.PARAMETER CertificateThumbprint
	See Invoke-WebRequest
	The thumbprint of the certificate to use for client certificate authentication.

	.PARAMETER ContentType
	Specifies the content type of the web request.

	.PARAMETER Accept
	An Accept string to be included in the request header

	.EXAMPLE
	Invoke-IDRestMethod -Uri $URI -Method DELETE -WebSession $ISPSSSession.WebSession

	Send request to web service
	#>
	[CmdletBinding(DefaultParameterSetName = 'WebSession')]
	param
	(
		[Parameter(Mandatory = $true)]
		[ValidateSet('GET', 'POST', 'PUT', 'DELETE', 'PATCH')]
		[String]$Method,

		[Parameter(Mandatory = $true)]
		[String]$URI,

		[Parameter(Mandatory = $false)]
		[Object]$Body,

		[Parameter(Mandatory = $false)]
		[hashtable]$Headers,

		[Parameter(
			Mandatory = $false,
			ParameterSetName = 'SessionVariable'
		)]
		[String]$SessionVariable,

		[Parameter(
			Mandatory = $false,
			ParameterSetName = 'WebSession'
		)]
		[Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,

		[Parameter(Mandatory = $false)]
		[switch]$UseDefaultCredentials,

		[Parameter(Mandatory = $false)]
		[PSCredential]$Credential,

		[Parameter(Mandatory = $false)]
		[int]$TimeoutSec,

		[Parameter(Mandatory = $false)]
		[X509Certificate]$Certificate,

		[Parameter(Mandatory = $false)]
		[string]$CertificateThumbprint,

		[Parameter(Mandatory = $false)]
		[string]$ContentType,

		[Parameter(Mandatory = $false)]
		[string]$Accept
	)

	Begin {

		#Set defaults for all function calls
		$ProgressPreference = 'SilentlyContinue'
		$PSBoundParameters.Add('UseBasicParsing', $true)

		if ($null -ne $ISPSSSession.WebSession) {

			#use the WebSession if it exists in the module scope, and alternate session is not specified.
			if ( -not ($PSBoundParameters.ContainsKey('WebSession'))) {

				$PSBoundParameters.Add('WebSession', $ISPSSSession.WebSession)

			}

		}

		#Unless otherwise specified, expected content type is json
		if ( -not ($PSBoundParameters.ContainsKey('ContentType'))) {

			$PSBoundParameters.Add('ContentType', 'application/json')

		}

		#Bypass strict RFC header parsing in PS Core
		#Use TLS 1.2
		if ($IsCoreCLR) {

			$PSBoundParameters.Add('SkipHeaderValidation', $true)
			$PSBoundParameters.Add('SslProtocol', 'TLS12')

		}

		#If Tls12 Security Protocol is available
		if (([Net.SecurityProtocolType].GetEnumNames() -contains 'Tls12') -and

			#And Tls12 is not already in use
			(-not ([System.Net.ServicePointManager]::SecurityProtocol -match 'Tls12'))) {

			[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

		}

	}

	Process {

		#Show sanitised request body if in debug mode
		If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {

			If (($PSBoundParameters.ContainsKey('Body')) -and (($PSBoundParameters['Body']).GetType().Name -eq 'String')) {

				Write-Debug "[Body] $(Hide-SecretValue -InputValue $Body)"

			}

		}

		try {

			#make web request, splat PSBoundParameters
			$APIResponse = Invoke-WebRequest @PSBoundParameters -ErrorAction Stop

		} catch [System.UriFormatException] {

			#Catch URI Format errors. Likely module scope url is not set; New-IDSession should be run.
			$PSCmdlet.ThrowTerminatingError(

				[System.Management.Automation.ErrorRecord]::new(

					"$PSItem Run New-IDSession",
					$null,
					[System.Management.Automation.ErrorCategory]::NotSpecified,
					$PSItem

				)

			)

		} catch {
			#catch other errors

			If ($null -ne $($PSItem)) {

				$ISPSSSession.LastError = $PSItem
				$ISPSSSession.LastErrorTime = Get-Date

				$ErrorID = $PSItem | Select-Object -ExpandProperty FullyQualifiedErrorId

				try {

					$ErrorDetails = $PSItem.ErrorDetails | ConvertFrom-Json -ErrorAction Stop
					$validJson = $true

				} catch {

					$validJson = $false
					$ErrorMessage = $null

				} finally {

					if ($validJson) {

						$ErrorMessage = $ErrorDetails | Select-Object -ExpandProperty Message
						If ($null -ne $ErrorDetails.Description) {
							$ErrorDescription = $ErrorDetails | Select-Object -ExpandProperty Description
							$ErrorMessage = "$ErrorMessage. $ErrorDescription"
						}
						If ($null -ne $ErrorDetails.code) {
							$ErrorID, $ErrorDetails.code -join ','
						}

					} else {

						$ErrorMessage = $PSItem.ErrorDetails

					}

					#throw the error
					$PSCmdlet.ThrowTerminatingError(

						[System.Management.Automation.ErrorRecord]::new(

							$ErrorMessage,
							$ErrorID,
							[System.Management.Automation.ErrorCategory]::NotSpecified,
							$PSItem

						)

					)
				}
			}

		} finally {

			#Add Command Data to $ISPSSSession module scope variable
			$ISPSSSession.LastCommand = Get-ParentFunction | Select-Object -ExpandProperty CommandData
			$ISPSSSession.LastCommandResults = $APIResponse
			$ISPSSSession.LastCommandTime = Get-Date

			#If Session Variable passed as argument
			If ($PSCmdlet.ParameterSetName -eq 'SessionVariable') {

				#Make the WebSession available in the module scope
				$ISPSSSession.WebSession = $(Get-Variable $(Get-Variable sessionVariable).Value).Value

			}

			#If Command Succeeded
			if ($?) {

				#Status code indicates success
				If ($APIResponse.StatusCode -match '^20\d$') {

					#Pass APIResponse to Get-IDResponse
					$APIResponse | Get-IDResponse

				}

			}

		}

	}

	End { }

}

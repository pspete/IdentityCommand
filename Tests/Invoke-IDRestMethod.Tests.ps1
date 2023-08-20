Describe $($PSCommandPath -Replace '.Tests.ps1') {

	BeforeAll {
		#Get Current Directory
		$Here = Split-Path -Parent $PSCommandPath

		#Assume ModuleName from Repository Root folder
		$ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

		#Resolve Path to Module Directory
		$ModulePath = Resolve-Path "$Here\..\$ModuleName"

		#Define Path to Module Manifest
		$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

		if ( -not (Get-Module -Name $ModuleName -All)) {

			Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop

		}

	}

	InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

		Context 'Standard Operation' {

			BeforeEach {

				$Response = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$Response | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$Response | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'application/json; charset=utf-8' } -Force
				$Response | Add-Member -MemberType NoteProperty -Name Content -Value (@{
						'success' = $true
						'Result'  = @{
							'prop1'   = 'value1'
							'prop2'   = 'value2'
							'prop123' = 123
							'test'    = 321
						}
					} | ConvertTo-Json) -Force

				$Failure = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$Failure | Add-Member -MemberType NoteProperty -Name StatusCode -Value 409 -Force

				Mock Invoke-WebRequest -MockWith {

					return $Response

				}

				$SessionVariable = @{
					'URI'             = 'https://CyberArk_URL'
					'Method'          = 'GET'
					'SessionVariable' = 'varSession'
				}

				$WebSession = @{
					'URI'        = 'https://CyberArk_URL'
					'Method'     = 'GET'
					'WebSession' = New-Object Microsoft.PowerShell.Commands.WebRequestSession
					'Body'       = 'something'
				}

				Set-Variable varSession -Value $(New-Object Microsoft.PowerShell.Commands.WebRequestSession)
				$VarSession.Headers['Test'] = 'OK'

			}

			It 'does not throw' {

				{ $DebugPreference = 'Continue'
					Invoke-IDRestMethod @WebSession 5>&1
					$DebugPreference = 'SilentlyContinue' } | Should -Not -Throw

			}
			It 'sends request' {

				Invoke-IDRestMethod @WebSession
				Assert-MockCalled 'Invoke-WebRequest' -Times 1 -Scope It -Exactly

			}

			if ([Net.SecurityProtocolType].GetEnumNames() -contains 'Tls12') {

				It 'enforces use of TLS 1.2' {
					[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls11
					Invoke-IDRestMethod @WebSession
					[System.Net.ServicePointManager]::SecurityProtocol | Should -Be Tls12
				}

			}

			It 'specifies -SslProtocol TLS12' {

				If ($IsCoreCLR) {

					Mock Invoke-WebRequest -MockWith { }
					Invoke-IDRestMethod @WebSession
					Assert-MockCalled 'Invoke-WebRequest' -Times 1 -Scope It -Exactly -ParameterFilter {
						$SslProtocol -eq 'TLS12'
					}
				} else { Set-ItResult -Inconclusive }
			}

			It 'specifies SkipHeaderValidation' {

				If ($IsCoreCLR) {
					Mock Invoke-WebRequest -MockWith { }

					Invoke-IDRestMethod @WebSession
					Assert-MockCalled 'Invoke-WebRequest' -Times 1 -Scope It -Exactly -ParameterFilter {
						$SkipHeaderValidation -eq $true
					}
				} else { Set-ItResult -Inconclusive }
			}

			It 'sets WebSession variable in the module scope' {
				Invoke-IDRestMethod @SessionVariable
				$Script:WebSession | Should -Not -BeNullOrEmpty
			}

			It 'returns WebSession sessionvariable value' {
				Invoke-IDRestMethod @SessionVariable
				$Script:WebSession.Headers['Test'] | Should -Be 'OK'
			}

			It 'sends output to Get-IDResponse' {
				Mock Get-IDResponse { }
				Invoke-IDRestMethod @WebSession
				Assert-MockCalled 'Get-IDResponse' -Times 1 -Scope It -Exactly
			}

			It 'does not invoke Get-IDResponse if there an error code indicating failure' {
				Mock Invoke-WebRequest -MockWith {

					return $Failure

				}
				Mock Get-IDResponse { }
				Invoke-IDRestMethod @WebSession
				Assert-MockCalled 'Get-IDResponse' -Times 0 -Scope It -Exactly
			}

		}

		Context 'Error Handling' {

			BeforeEach {

				If ($IsCoreCLR) {
					$errorDetails = $([pscustomobject]@{'ErrorCode' = 'URA999'; 'ErrorMessage' = 'Some Error Message' } | ConvertTo-Json)
					$statusCode = 400
					$response = New-Object System.Net.Http.HttpResponseMessage $statusCode
					$exception = New-Object Microsoft.PowerShell.Commands.HttpResponseException "$statusCode ($($response.ReasonPhrase))", $response
					$errorCategory = [System.Management.Automation.ErrorCategory]::InvalidOperation
					$errorID = 'WebCmdletWebResponseException,Microsoft.PowerShell.Commands.InvokeWebRequestCommand'
					$targetObject = $null
					$errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
					$errorRecord.ErrorDetails = $errorDetails
				}

				$WebSession = @{
					'URI'        = 'https://CyberArk_URL'
					'Method'     = 'GET'
					'WebSession' = New-Object Microsoft.PowerShell.Commands.WebRequestSession
					'Body'       = 'something'
				}

			}

			It 'catches Uri Format Exceptions' {

				{ Invoke-IDRestMethod -Method GET -URI '/s/r/f/c' } | Should -Throw -ExpectedMessage 'Invalid URI: The hostname could not be parsed. Run New-IDSession'
			}

			It 'reports generic Http Request Exceptions' {

				$Credentials = New-Object System.Management.Automation.PSCredential ('SomeUser', $(ConvertTo-SecureString 'SomePassword' -AsPlainText -Force))
				{ New-IDSession -Credential $Credentials -BaseURI 'https://dead.server.no-site.io' } | Should -Throw

			}

			It 'reports expected error message' {
				If ($IsCoreCLR) {
					Mock Invoke-WebRequest { Throw $errorRecord }

					{ Invoke-IDRestMethod @WebSession } | Should -Throw
				} Else { Set-ItResult -Inconclusive }

			}

			It 'reports http errors not returned as json' {
				If ($IsCoreCLR) {
					$errorDetails = '"ErrorCode" [=] "URA999"[;] "ErrorMessage" [=] "Some Error Message"'
					$errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
					$errorRecord.ErrorDetails = $errorDetails
					Mock Invoke-WebRequest { Throw $errorRecord }
					{ Invoke-IDRestMethod @WebSession } | Should -Throw
				} Else { Set-ItResult -Inconclusive }
			}

			It 'reports inner error messages' {
				If ($IsCoreCLR) {
					$Details = [pscustomobject]@{'ErrorCode' = 'URA666'; 'ErrorMessage' = 'Some Inner Error' }
					$errorDetails = $([pscustomobject]@{'ErrorCode' = 'URA999'; 'ErrorMessage' = 'Some Error Message' ; 'Details' = $Details } | ConvertTo-Json)
					$errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
					$errorRecord.ErrorDetails = $errorDetails
					Mock Invoke-WebRequest { Throw $errorRecord }
					{ Invoke-IDRestMethod @WebSession } | Should -Throw
				} Else { Set-ItResult -Inconclusive }
			}

			It 'catches other errors' {
				If ($IsCoreCLR) {
					$errorDetails = $null
					$errorRecord = New-Object Management.Automation.ErrorRecord $exception, $errorID, $errorCategory, $targetObject
					$errorRecord.ErrorDetails = $errorDetails
					Mock Invoke-WebRequest { Throw $errorRecord }

					{ Invoke-IDRestMethod @WebSession } | Should -Throw
				} Else { Set-ItResult -Inconclusive }

			}

		}

	}

}
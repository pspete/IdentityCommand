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

				$JSONResponse = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$JSONResponse | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$JSONResponse | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'application/json; charset=utf-8' } -Force
				$JSONResponse | Add-Member -MemberType NoteProperty -Name Content -Value (@{
						'success' = $true
						'Result'  = @{
							'prop1'   = 'value1'
							'prop2'   = 'value2'
							'prop123' = 123
							'test'    = 321
						}
					} | ConvertTo-Json) -Force

				$TextResponse = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$TextResponse | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$TextResponse | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'text/html; charset=utf-8' } -Force
				$TextResponse | Add-Member -MemberType NoteProperty -Name Content -Value '"Value"' -Force

				$HTMLResponse = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$HTMLResponse | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$HTMLResponse | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'text/html; charset=utf-8' } -Force
				$HTMLResponse | Add-Member -MemberType NoteProperty -Name Content -Value '<HTML><HEAD><BODY><P>Test</P></BODY></HEAD></HTML>' -Force

				$ApplicationSave = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$ApplicationSave | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$ApplicationSave | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'application/save' ; 'Content-Disposition' = 'attachment; filename=FILENAME.zip' } -Force
				$ApplicationSave | Add-Member -MemberType NoteProperty -Name Content -Value $([System.Text.Encoding]::Ascii.GetBytes('Expected')) -Force

				$OctetStream = New-MockObject -Type Microsoft.PowerShell.Commands.WebResponseObject
				$OctetStream | Add-Member -MemberType NoteProperty -Name StatusCode -Value 200 -Force
				$OctetStream | Add-Member -MemberType NoteProperty -Name Headers -Value @{ 'Content-Type' = 'application/octet-stream' ; 'Content-Disposition' = 'attachment; filename=FILENAME.zip' } -Force
				$OctetStream | Add-Member -MemberType NoteProperty -Name Content -Value $([System.Text.Encoding]::Ascii.GetBytes('Expected')) -Force

			}

			It 'returns expected number of properties' {
				$result = Get-IDResponse -APIResponse $JSONResponse
				($result | Get-Member -MemberType NoteProperty).length | Should -Be 4
			}

			It 'returns expected text value' {
				Get-IDResponse -APIResponse $TextResponse | Should -Be '"Value"'
			}

			It 'throws if HTML received' {
				{ Get-IDResponse -APIResponse $HTMLResponse } | Should -Throw
			}

			It 'has no output if HTML expetted' {
				$Script:ExpectHtml = $true
				Get-IDResponse -APIResponse $HTMLResponse | Should -BeNullOrEmpty
				$Script:ExpectHtml = $false
			}

		}

	}

}
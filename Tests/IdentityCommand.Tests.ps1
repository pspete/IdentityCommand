#Requires -Modules Pester
<#
.SYNOPSIS
    Tests IdentityCommand-specific conventions across the module.
.EXAMPLE
    Invoke-Pester
.NOTES
    The generic module tests come from pspete.Build (build/tests/Module.Tests.ps1).
    The built module is a single psm1 with no Public folder, so Secure Value Handling finds no scripts to check against it.
#>

Describe 'Module' -Tag 'Consistency' {

	$ModuleName = 'IdentityCommand'

	$ModulePath = Join-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) $ModuleName

	$Scripts = Get-ChildItem $ModulePath -Include *.ps1 -Recurse

	Context 'Secure Value Handling' -Tag 'SecureValueHandling' {

		#Any function that decodes a SecureString (or otherwise obtains a plaintext secret - e.g.
		#from a credential, an already-decoded answer, or a plaintext CSV field for one of the same
		#field names Hide-SecretValue redacts) and sends a JSON request body via Invoke-IDRestMethod
		#must convert that body to UTF8 bytes (not a String) before the call, so Windows PowerShell
		#ParameterBinding/Module Logging cannot capture the plaintext value.
		#See https://github.com/pspete/psPAS/issues/602

		$SecretFieldNames = 'Password', 'Answer', 'NewCredentials', 'NewPassword', 'BindPassword', 'InitialPassword', 'clientSecret', 'keyPassword', 'defaultPassword'
		$SecretFieldPattern = "(?i)'($($SecretFieldNames -join '|'))'"
		$SecretDecodePattern = 'ConvertTo-InsecureString|Unprotect-Answer'

		Foreach ($Script in $Scripts) {

			$Content = Get-Content -Path $Script.FullName -Raw

			$HandlesSecret = ($Content -match $SecretFieldPattern) -or ($Content -match $SecretDecodePattern)
			$BuildsJsonBody = $Content -match 'ConvertTo-Json'
			$SendsRequest = $Content -match 'Invoke-IDRestMethod'

			if ($HandlesSecret -and $BuildsJsonBody -and $SendsRequest) {

				It "$($Script.Name) converts its request body to UTF8 bytes before calling Invoke-IDRestMethod" -Tag "$($Script.BaseName)" -TestCases @{
					'Content' = $Content
				} {
					param($Content)

					$Content | Should -Match '\[System\.Text\.Encoding\]::UTF8\.GetBytes\('

				}

			}

		}

		#The pattern-based scan above can't see a secret that only exists in the *caller's* data
		#The pattern-based scan above can't see a secret that only exists in the *caller's* data
		#(e.g. a hashtable value passed in via a parameter) rather than as literal source text in
		#the file itself - these are known to handle a secret this way, so are named explicitly
		if ($Scripts) {

			'Set-IDUserSecurityQuestion.ps1', 'Submit-PersonalApplicationCsvImport.ps1', 'Test-PersonalApplicationCsvImport.ps1' | ForEach-Object {

				$ScriptName = $PSItem
				$Script = $Scripts | Where-Object Name -EQ $ScriptName

				It "$ScriptName converts its request body to UTF8 bytes before calling Invoke-IDRestMethod" -Tag "$($Script.BaseName)" -TestCases @{
					'Content' = Get-Content -Path $Script.FullName -Raw
				} {
					param($Content)

					$Content | Should -Match '\[System\.Text\.Encoding\]::UTF8\.GetBytes\('

				}

			}

		}

	}

}

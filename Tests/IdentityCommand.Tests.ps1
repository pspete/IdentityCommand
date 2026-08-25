#Requires -Modules Pester, PSScriptAnalyzer
<#
.SYNOPSIS
    Tests module for consistency, expected structures, settings, components & files.
.EXAMPLE
    Invoke-Pester
.NOTES
    A generic set of tests to apply to a module
#>

Describe 'Module' -Tag 'Consistency' {

	#Get Current Directory
	$Here = Split-Path -Parent $PSCommandPath

	#Assume ModuleName from Repository Root folder
	$ModuleName = Split-Path (Split-Path $Here -Parent) -Leaf

	#Resolve Path to Module Directory
	$ModulePath = Resolve-Path "$Here\..\$ModuleName"

	#Define Path to Module Manifest
	$ManifestPath = Join-Path "$ModulePath" "$ModuleName.psd1"

	Get-Module -Name $ModuleName -All | Remove-Module -Force -ErrorAction Ignore

	$Module = Import-Module -Name "$ManifestPath" -ArgumentList $true -Force -ErrorAction Stop -PassThru

	#Get Public Function Names
	$PublicFunctions = Get-ChildItem "$ModulePath\Public" -Include *.ps1 -Recurse | Select-Object -ExpandProperty BaseName

	#Get Exported Function Names
	$ExportedFunctions = $Module.ExportedFunctions.Values.name

	$ExportedAliases = $Module.ExportedAliases.Values.name

	$Scripts = Get-ChildItem $ModulePath -Include *.ps1 -Recurse

	$Rules = Get-ScriptAnalyzerRule -Severity Warning, Error

	Context $ManifestPath -Tag Manifest {

		It 'has a valid manifest' -TestCases @{ManifestPath = $ManifestPath } {
			param($ManifestPath)
			{ $null = Test-ModuleManifest -Path $ManifestPath -ErrorAction Stop -WarningAction SilentlyContinue } |
				Should -Not -Throw

		}

		It 'specifies valid root module' -TestCases @{RootModule = $Module.RootModule ; ModuleName = $ModuleName } {
			param($RootModule, $ModuleName)
			$RootModule | Should -Be "$ModuleName.psm1"

		}

		It 'has a valid description' -TestCases @{Description = $Module.Description } {
			param($Description)
			$Description | Should -Not -BeNullOrEmpty

		}

		It 'has a valid guid' -TestCases @{Guid = $Module.Guid } {
			param($Guid)
			$Guid | Should -Be 'f6bb2bdf-0c53-443f-be07-3c25264a09b1'

		}

		It 'has a valid copyright' -TestCases @{Copyright = $Module.Copyright } {
			param($Copyright)
			$Copyright | Should -Not -BeNullOrEmpty

		}

		Context 'Files To Process' -Tag 'FilesToProcess' {

			foreach ($file in ($Module.ExportedFormatFiles)) {
				Context $file -Tag 'FormatData' {
					It 'exists' -TestCases @{
						'File' = $file
					} {
						param($File)
						$File | Should -Exist
					}

					It 'is valid' -TestCases @{
						'File' = $file
					} {
						param($File)
						{ Update-FormatData -AppendPath $File -ErrorAction Stop -WarningAction SilentlyContinue } | Should -Not -Throw
					}

				}

				foreach ($file in ($Module.ExportedTypeFiles)) {
					Context $file -Tag 'TypeData' {
						It 'exists' -TestCases @{
							'File' = $file
						} {
							param($File)
							$File | Should -Exist
						}

						It 'is valid' -TestCases @{
							'File' = $file
						} {
							param($File)
							{ Update-TypeData -AppendPath $File -ErrorAction Stop -WarningAction SilentlyContinue } | Should -Not -Throw
						}

					}
				}
			}
		}

		Context 'Exported Function Analysis' -Tag 'Functions' {

			It 'exports the expected number of functions' {

				($PublicFunctions | Measure-Object | Select-Object -ExpandProperty Count) |

					Should -Be ($ExportedFunctions | Measure-Object | Select-Object -ExpandProperty Count)

			}

			foreach ($ExportedFunction in $ExportedFunctions) {

				Context "$ExportedFunction" -Tag "$ExportedFunction" {
					It 'is public' -TestCases @{
						'ExportedFunction' = $ExportedFunction
						'PublicFunctions'  = $PublicFunctions
					} {
						param($ExportedFunction, $PublicFunctions)
						$PublicFunctions | Should -Contain $ExportedFunction
					}

					It 'has a related pester tests file' -TestCases @{
						'ExportedFunction' = $ExportedFunction
						'Here'             = $here
					} {
						param($ExportedFunction, $here)
						Test-Path (Join-Path $here "$ExportedFunction.Tests.ps1") | Should -Be $true
					}

					Context Help -Tag 'Help' {

						$help = Get-Help $ExportedFunction -Full

						It 'has synopsis' -TestCases @{ 'Help' = $help } {
							param($help)
							$help.synopsis | Should -Not -BeNullOrEmpty

						}

						It 'has description' -TestCases @{ 'Help' = $help } {
							param($help)
							$help.description | Should -Not -BeNullOrEmpty

						}

						It 'has example code' -TestCases @{ 'Help' = $help } {
							param($help)
							$help.examples.example.code | Should -Not -BeNullOrEmpty

						}

						[array]$HelpParameters = $help.parameters.parameter | Where-Object name -NotIn @('WhatIf', 'Confirm')

						foreach ($HelpParameter in $HelpParameters) {

							It 'has description of parameter <name>' -Tag "$($HelpParameter.name)" -TestCases @{
								'description' = $HelpParameter.description
								'name'        = $HelpParameter.name
							} {
								param($description, $name)
								$description | Should -Not -BeNullOrEmpty
							}

						}

					}
				}

			}

		}

		Context 'Exported Alias Analysis' -Tag Alias {

			foreach ($Alias in $ExportedAliases) {

				It '<Alias> resolves to public function' -Tag $Alias -TestCases @{
					'Alias'           = $Alias
					'PublicFunctions' = $PublicFunctions
				} {
					param($Alias, $PublicFunctions)
					$PublicFunctions | Should -Contain $((Get-Alias $Alias).ResolvedCommand.Name)
				}

			}

		}

	}

	Context 'PSScriptAnalyzer Analysis' -Tag 'PSScriptAnalyzer' {

		Foreach ($Script in $scripts) {

			Context $Script.Name -Tag "$($Script.BaseName)", "$($Script.Name)" {

				Foreach ($rule in $rules) {

					It 'passes rule: <RuleName>' -Tag $rule -TestCases @{
						'RuleName' = $rule.RuleName
						'FileName' = $script.Name
						'FilePath' = $script.FullName
					} {
						param($RuleName, $FileName, $FilePath)

						Invoke-ScriptAnalyzer -Path $FilePath -IncludeRule $RuleName | Should -BeNullOrEmpty

					}

				}

			}

		}

	}

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
		#(e.g. a hashtable value passed in via a parameter) rather than as literal source text in
		#the file itself - these are known to handle a secret this way, so are named explicitly
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
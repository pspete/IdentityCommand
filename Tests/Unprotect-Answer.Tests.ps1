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

        $Script:RequestBody = $null
        $Script:tenant_url = 'https://somedomain.id.cyberark.cloud'
        $Script:WebSession = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    }

    InModuleScope $(Split-Path (Split-Path (Split-Path -Parent $PSCommandPath) -Parent) -Leaf ) {

        Context 'General' {

            BeforeEach {
                $SecureString = $(ConvertTo-SecureString 'SomeSecureString' -AsPlainText -Force)
            }
            It 'converts SecureString to cleartext' {

                Unprotect-Answer $SecureString | Should -Be SomeSecureString

            }

            It 'converts hashtable SecureString value to cleartext' {

                $Hashtable = @{'Key' = $SecureString }
                $Result = Unprotect-Answer $Hashtable
                $Result['Key'] | Should -Be SomeSecureString

            }

            It 'converts multiple hashtable SecureString values to cleartext' {

                $Hashtable = @{'Key1' = $SecureString; 'Key2' = $SecureString }
                $Result = Unprotect-Answer $Hashtable
                $Result['Key1'] | Should -Be SomeSecureString
                $Result['Key2'] | Should -Be SomeSecureString

            }

        }

    }

}
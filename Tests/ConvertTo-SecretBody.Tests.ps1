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

        It 'returns a UTF8 byte array' {
            $result = @{ 'password' = 'SomeSecret' } | ConvertTo-SecretBody
            $result -is [byte[]] | Should -BeTrue
        }

        It 'round-trips the object through JSON' {
            $body = [ordered]@{ 'name' = 'acct'; 'secret' = @{ 'password' = 'p' } } | ConvertTo-SecretBody
            $request = [System.Text.Encoding]::UTF8.GetString($body) | ConvertFrom-Json
            $request.name | Should -Be 'acct'
            $request.secret.password | Should -Be 'p'
        }

        It 'restores an -EmptyArrayProperty to []' {
            $body = [ordered]@{ 'domains' = @() } | ConvertTo-SecretBody -EmptyArrayProperty domains
            $json = [System.Text.Encoding]::UTF8.GetString($body)
            $json | Should -Match '"domains"\s*:\s*\[\]'
        }

        It 'leaves other empty-string values untouched' {
            $body = [ordered]@{ 'domains' = @(); 'domain' = '' } | ConvertTo-SecretBody -EmptyArrayProperty domains
            $json = [System.Text.Encoding]::UTF8.GetString($body)
            $json | Should -Match '"domain"\s*:\s*""'
        }

        It 'honours -Depth for nested structures' {
            $deep = [ordered]@{ l1 = [ordered]@{ l2 = [ordered]@{ l3 = [ordered]@{ l4 = 'value' } } } }
            $request = [System.Text.Encoding]::UTF8.GetString(($deep | ConvertTo-SecretBody -Depth 8)) | ConvertFrom-Json
            $request.l1.l2.l3.l4 | Should -Be 'value'
        }
    }

}

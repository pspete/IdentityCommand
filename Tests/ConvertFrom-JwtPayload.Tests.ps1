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

        Context 'General' {

            BeforeAll {
                #{"subdomain":"sometenant","platform_domain":"cyberark.cloud"} - base64url, unpadded
                $Jwt = 'eyJhbGciOiJub25lIn0.eyJzdWJkb21haW4iOiJzb21ldGVuYW50IiwicGxhdGZvcm1fZG9tYWluIjoiY3liZXJhcmsuY2xvdWQifQ.c2ln'
            }

            It 'returns the payload claims of a raw token' {
                $Claims = ConvertFrom-JwtPayload -Token $Jwt
                $Claims.subdomain | Should -Be 'sometenant'
                $Claims.platform_domain | Should -Be 'cyberark.cloud'
            }

            It 'accepts an Authorization header value' {
                (ConvertFrom-JwtPayload -Token "Bearer $Jwt").subdomain | Should -Be 'sometenant'
            }

            It 'accepts pipeline input' {
                ($Jwt | ConvertFrom-JwtPayload).subdomain | Should -Be 'sometenant'
            }

            It 'decodes base64url characters' {
                #{"n":"a?>b"} encodes with a '_' in base64url
                (ConvertFrom-JwtPayload -Token 'e30.eyJuIjoiYT8-YiJ9.c2ln').n | Should -Be 'a?>b'
            }

            It 'throws when the value is not a JWT' {
                { ConvertFrom-JwtPayload -Token 'SomeAccessToken' } | Should -Throw 'Token is not a JWT'
            }

        }

    }

}

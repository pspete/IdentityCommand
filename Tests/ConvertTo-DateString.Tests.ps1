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

        It 'formats a date as an ISO 8601 UTC string' {
            ConvertTo-DateString -Date ([datetime]::new(2022, 7, 12, 14, 30, 0, [System.DateTimeKind]::Utc)) |
                Should -Be '2022-07-12T14:30:00.000Z'
        }

        It 'converts a local time to UTC' {
            $Local = [datetime]::new(2022, 7, 12, 14, 30, 0, [System.DateTimeKind]::Local)
            ConvertTo-DateString -Date $Local | Should -Be "$($Local.ToUniversalTime().ToString('yyyy-MM-ddTHH:mm:ss.fff'))Z"
        }

        It 'accepts pipeline input' {
            ([datetime]::new(2022, 1, 1, 0, 0, 0, [System.DateTimeKind]::Utc) | ConvertTo-DateString) |
                Should -Be '2022-01-01T00:00:00.000Z'
        }
    }

}

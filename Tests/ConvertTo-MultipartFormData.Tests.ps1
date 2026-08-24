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

        Context 'Text field' {

            BeforeEach {
                $response = ConvertTo-MultipartFormData -Field @{ 'SomeField' = 'SomeValue' } -Boundary 'someboundary'
            }

            It 'returns a ContentType including the boundary' {

                $response.ContentType | Should -Be 'multipart/form-data; boundary=someboundary'

            }

            It 'returns a Body containing the field name' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'name="SomeField"'

            }

            It 'returns a Body containing the field value' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'SomeValue'

            }

        }

        Context 'File field' {

            BeforeAll {
                $TestFile = Join-Path $TestDrive 'test.txt'
                Set-Content -Path $TestFile -Value 'file content' -NoNewline
            }

            BeforeEach {
                $response = ConvertTo-MultipartFormData -Field @{ 'Picture' = (Get-Item -Path $TestFile) } -Boundary 'someboundary'
            }

            It 'returns a Body containing the file name' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'filename="test.txt"'

            }

            It 'returns a Body containing the file content' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'file content'

            }

            It 'defaults to application/octet-stream for an unrecognised extension' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'Content-Type: application/octet-stream'

            }

        }

        Context 'CSV file field' {

            BeforeAll {
                $TestCsvFile = Join-Path $TestDrive 'test.csv'
                Set-Content -Path $TestCsvFile -Value 'Login Name,Email Address' -NoNewline
            }

            BeforeEach {
                $response = ConvertTo-MultipartFormData -Field @{ 'Icon' = (Get-Item -Path $TestCsvFile) } -Boundary 'someboundary'
            }

            It 'sets the Content-Type to text/csv' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'Content-Type: text/csv'

            }

        }

        Context 'Image file field' {

            BeforeAll {
                $TestImageFile = Join-Path $TestDrive 'test.png'
                Set-Content -Path $TestImageFile -Value 'not a real png, just bytes' -NoNewline
            }

            BeforeEach {
                $response = ConvertTo-MultipartFormData -Field @{ 'Icon' = (Get-Item -Path $TestImageFile) } -Boundary 'someboundary'
            }

            It 'sets the Content-Type based on the file extension' {

                [System.Text.Encoding]::UTF8.GetString($response.Body) | Should -Match 'Content-Type: image/png'

            }

        }

    }

}

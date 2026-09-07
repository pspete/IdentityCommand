function ConvertTo-SecretBody {
    <#
    .SYNOPSIS
    Serialises a request body that carries a plaintext secret to UTF8 bytes.

    .DESCRIPTION
    Any command that decodes a SecureString and sends the plaintext in a JSON request body must hand
    Invoke-IDRestMethod a byte[] rather than a String, so Windows PowerShell ParameterBinding / Module
    Logging cannot capture the plaintext value (see https://github.com/pspete/psPAS/issues/602).

    This helper centralises that conversion: it runs ConvertTo-Json, optionally repairs empty-array
    properties that Windows PowerShell serialises as "" instead of [], and returns the UTF8 byte array.

    .EXAMPLE
    $StrongAccount | ConvertTo-SecretBody

    Serialises $StrongAccount and returns the body as a UTF8 byte array.

    .EXAMPLE
    $StrongAccount | ConvertTo-SecretBody -EmptyArrayProperty domains

    As above, but restores "domains":"" to "domains":[] for Windows PowerShell.
    #>
    [CmdletBinding()]
    [OutputType([byte[]])]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            Position = 0
        )]
        [object]$InputObject,

        [parameter(Mandatory = $false)]
        [int]$Depth = 5,

        [parameter(Mandatory = $false)]
        [string[]]$EmptyArrayProperty
    )

    process {

        $json = $InputObject | ConvertTo-Json -Depth $Depth

        foreach ($property in $EmptyArrayProperty) {

            #Windows PowerShell ConvertTo-Json serialises an empty array as "" - restore it to []
            $json = $json -replace ('("{0}"\s*:\s*)""' -f [regex]::Escape($property)), '$1[]'

        }

        #Send as UTF8 bytes (not a String) so the plaintext secret can't be captured by Windows PowerShell
        #ParameterBinding/Module Logging - https://github.com/pspete/psPAS/issues/602
        #Leading comma keeps the result a byte[] rather than being unrolled to object[] by the pipeline
        , [System.Text.Encoding]::UTF8.GetBytes($json)

    }

}

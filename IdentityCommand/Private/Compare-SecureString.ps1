function Compare-SecureString {
    <#
    .SYNOPSIS
    Compares 2 SecureString variables

    .DESCRIPTION
    Compares 2 SecureString variables

    .PARAMETER secureString1
    A SecureString to evaluate against secureString2

    .PARAMETER secureString2
    A SecureString to evaluate against secureString1

    .EXAMPLE
    Compare-SecureString -secureString1 $Secure1 -secureString2 $Secure2

    Checks $Secure1 against $Secure2 to confirm they match

    #>

    [CmdLetBinding()]
    [OutputType('System.Boolean')]
    Param (
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [System.Security.SecureString]$secureString1,

        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True
        )]
        [System.Security.SecureString]$secureString2
    )

    try {
        $bstr1 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString1)
        $bstr2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureString2)
        $length1 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr1, -4)
        $length2 = [Runtime.InteropServices.Marshal]::ReadInt32($bstr2, -4)
        if ( $length1 -ne $length2 ) {
            return $false
        }
        for ( $i = 0; $i -lt $length1; ++$i ) {
            $b1 = [Runtime.InteropServices.Marshal]::ReadByte($bstr1, $i)
            $b2 = [Runtime.InteropServices.Marshal]::ReadByte($bstr2, $i)
            if ( $b1 -ne $b2 ) {
                return $false
            }
        }
        return $true
    } finally {
        if ( $bstr1 -ne [IntPtr]::Zero ) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr1)
        }
        if ( $bstr2 -ne [IntPtr]::Zero ) {
            [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr2)
        }
    }
}
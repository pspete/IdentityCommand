Function ConvertFrom-IDApplicationPermissionGrant {
<#
.SYNOPSIS
Decodes an application permission ACE's Grant bitmask into named rights

.DESCRIPTION
Converts the raw Grant integer returned by Acl/GetRowAces (Application table) into the right
names Set-IDApplicationPermission uses, via the IdApplicationRight [Flags()] enum (defined in the
module's .psm1). Bit values confirmed live via a Set/Get round trip, one right at a time.

.PARAMETER Grant
The raw Grant bitmask value from an Acl/GetRowAces entry

.EXAMPLE
ConvertFrom-IDApplicationPermissionGrant -Grant 2147483869

Returns Grant, View, Admin, ViewDetail, Delete, Execute, Automatic
#>
    [CmdletBinding()]
    [OutputType('System.String[]')]
    param(
        [parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [Int64]$Grant
    )

    PROCESS {

        #IdApplicationRight has no explicit base type (Windows PowerShell doesn't support one), so
        #it's backed by the default Int32 - values above Int32.MaxValue need wrapping into its
        #negative range first (same bit pattern, e.g. bit 31/2147483648 becomes Int32.MinValue)
        $Bits = if ($Grant -gt [Int32]::MaxValue) { $Grant - 4294967296 } else { $Grant }
        $Rights = [IdApplicationRight][Int32]$Bits

        if ($Rights -ne 0) { $Rights.ToString() -split ', ' }

    }#process

}

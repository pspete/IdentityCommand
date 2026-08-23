<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.INPUTS

.OUTPUTS
#>
[CmdletBinding()]
param(

    [bool]$DotSourceModule = $false

)

#Named rights for application permission grants (Acl/GetRowAces & SaasManage/SetApplicationPermissions)
#Bit values confirmed live via a Set-IDApplicationPermission/Get-IDApplicationPermission round trip.
#Automatic is bit 31 (2147483648) - written as Int32.MinValue since Windows PowerShell doesn't
#support an explicit enum base type, so this has to fit the default Int32 backing
[Flags()] enum IdApplicationRight {
    Grant      = 1
    View       = 4
    Admin      = 8
    ViewDetail = 16
    Delete     = 64
    Execute    = 128
    Automatic  = -2147483648
}

#Get function files
Get-ChildItem $PSScriptRoot\ -Recurse -Include '*.ps1' -Exclude '*.ps1xml' |

    ForEach-Object {

        if ($DotSourceModule) {
            . $_.FullName
        } else {
            $ExecutionContext.InvokeCommand.InvokeScript(
                $false,
                (
                    [scriptblock]::Create(
                        [io.file]::ReadAllText(
                            $_.FullName,
                            [Text.Encoding]::UTF8
                        )
                    )
                ),
                $null,
                $null
            )

        }

    }

# Script scope session object for session data
$ISPSSSession = [ordered]@{
    tenant_url         = $null
    User               = $null
    TenantId           = $null
    SessionId          = $null
    WebSession         = $null
    StartTime          = $null
    ElapsedTime        = $null
    LastCommand        = $null
    LastCommandTime    = $null
    LastCommandResults = $null
    LastError          = $null
    LastErrorTime      = $null
} | Add-CustomType -Type IdCmd.Session

New-Variable -Name ISPSSSession -Value $ISPSSSession -Scope Script -Force
# .ExternalHelp IdentityCommand-help.xml
Function Get-IDSession {

    [CmdletBinding()]
    Param ()

    Get-Variable -Name WebSession -Scope Script -ValueOnly

}
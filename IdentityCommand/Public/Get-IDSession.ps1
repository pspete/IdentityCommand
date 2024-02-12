# .ExternalHelp IdentityCommand-help.xml
Function Get-IDSession {

    [CmdletBinding()]
    Param ()

    BEGIN { }#begin

    PROCESS {

        #Calculate the time elapsed since the start of the session and include in return data
        if ($null -ne $ISPSSSession.StartTime) {
            $ISPSSSession.ElapsedTime = '{0:HH:mm:ss}' -f ([datetime]$($(Get-Date) - $($ISPSSSession.StartTime)).Ticks)
        } else { $ISPSSSession.ElapsedTime = $null }

        #Deep Copy the $psPASSession session object and return as psPAS Session type.
        Get-SessionClone -InputObject $ISPSSSession | Add-CustomType -Type IdCmd.Session

    }#process

    END { }#end

}
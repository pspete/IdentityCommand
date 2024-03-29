Function Clear-AdvanceAuthentication {
    <#
    .SYNOPSIS
    Performs Cleanup of actions performed during advance authentication stage

    .DESCRIPTION
    Sends request containing module scope variables for SessionID & TenantId to the CleanupAuthentication API.
    This clears the incomplete authentication session.

    .EXAMPLE
    Clear-AdvanceAuthentication

    Clears the current in-progress authenitcation session

    .NOTES
    Pete Maan 2023
    #>

    [CmdletBinding(SupportsShouldProcess)]
    param()

    Begin {
        $LogonRequest = @{}
    }

    Process {

        $Body = @{
            TenantId  = $ISPSSSession.TenantId
            SessionId = $ISPSSSession.SessionId
        }

        $LogonRequest['Uri'] = "$($ISPSSSession.tenant_url)/Security/CleanupAuthentication"
        $LogonRequest['Method'] = 'POST'
        $LogonRequest['Body'] = $Body | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($($ISPSSSession.SessionId), 'Clear Authentication Session')) {

            Invoke-IDRestMethod @LogonRequest | Out-Null

        }
    }

    End {}

}
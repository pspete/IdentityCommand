Function Clear-AdvanceAuthentication {

    [CmdletBinding(SupportsShouldProcess)]
    param()

    Begin {}

    Process {

        $Body = @{
            TenantId  = $Script:TenantId
            SessionId = $Script:SessionId
        }

        $LogonRequest['Uri'] = "$Script:tenant_url/Security/CleanupAuthentication"
        $LogonRequest['Body'] = $Body | ConvertTo-Json

        if ($PSCmdlet.ShouldProcess($Script:SessionId, 'Clear Authentication Session')) {

            Invoke-IDRestMethod @LogonRequest | Out-Null

        }
    }

    End {}

}
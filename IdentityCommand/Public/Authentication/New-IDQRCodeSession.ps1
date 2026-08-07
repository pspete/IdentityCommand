# .ExternalHelp IdentityCommand-help.xml
# UNTESTED: This command has not yet been verified against a live tenant - confirm it behaves as
# expected before relying on it in production.
# TODO: The exact mechanics of this flow are unconfirmed. StartQRCodeAuthentication and
# GetQRCodeStatus both take a 'guid' parameter, but no sample request/response shows where that
# guid originates from. This command generates its own client-side GUID and threads it through
# both calls, on the assumption it's a caller-supplied correlation token (e.g. one that would be
# embedded in a QR code image for a mobile authenticator app to scan and report back against) -
# this is a guess, not a confirmed API contract. This also assumes GetQRCodeStatus's response has
# a 'Summary' field that reads 'Pending' while waiting, mirroring how the credential authentication
# flow's OOB polling in Start-AdvanceAuthentication.ps1 detects a pending state - also unconfirmed.
# Nothing in this command displays the actual QR code image to the user, since it's unclear what
# the QR code's content should even be.
function New-IDQRCodeSession {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [parameter(Mandatory = $false)]
        [ValidateRange(1, 60)]
        [Int]$PollIntervalSeconds = 2,

        [parameter(Mandatory = $false)]
        [ValidateRange(1, 3600)]
        [Int]$TimeoutSeconds = 120
    )

    BEGIN {}#begin

    PROCESS {

        if ($PSCmdlet.ShouldProcess($ISPSSSession.tenant_url, 'Start QR Code Authentication')) {

            $Guid = [System.Guid]::NewGuid().ToString()

            $StartRequest = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Security/StartQRCodeAuthentication"
                'Method' = 'POST'
                'Body'   = (@{ 'guid' = $Guid } | ConvertTo-Json)

            }

            $null = Invoke-IDRestMethod @StartRequest

            Write-Verbose 'QR code authentication started. Polling for status...'

            $StatusRequest = @{

                'URI'    = "$($ISPSSSession.tenant_url)/Security/GetQRCodeStatus"
                'Method' = 'POST'
                'Body'   = (@{ 'guid' = $Guid } | ConvertTo-Json)

            }

            $Elapsed = 0
            $Status = $null

            do {

                Start-Sleep -Seconds $PollIntervalSeconds
                $Elapsed += $PollIntervalSeconds
                $Status = Invoke-IDRestMethod @StatusRequest

            } while (($Status.Summary -match 'Pending') -and ($Elapsed -lt $TimeoutSeconds))

            $Status

        }

    }#process

    END {}#end

}

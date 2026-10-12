function Resolve-RequestUrl {
    <#
    .SYNOPSIS
    Composes a companion module request URL, connecting the module to the IdentityCommand session on demand.

    .DESCRIPTION
    Used by the IdentityCommand.* companion modules, which copy this function into their own scope,
    so $ISPSSSession and $Script:ServiceKey here are the companion module's own.

    Before composing the URL, the companion module session is synchronised with the IdentityCommand
    session returned by Get-IDSession:

      - If there is no IdentityCommand session, the module session is used as is; an error is thrown
        if it holds no service URL.
      - If the IdentityCommand session has been closed (Close-IDSession) since it was copied, the
        copied session values are cleared, and an error is thrown.
      - If the IdentityCommand session has changed since it was last copied (a different StartTime),
        its values are copied into the module session. The service URL is kept only if the shared
        services subdomain is unchanged.

    If the module session holds no service URL, it is resolved from platform discovery using the
    subdomain read from the IdentityCommand session token, and kept for later requests.

    A service URL set by the companion module's Connect- command is used as is.

    .PARAMETER Path
    The path of the operation under the service URL, with or without a leading forward slash.
    Any path parameter values must already be escaped by the caller.

    .PARAMETER Service
    The platform discovery key of the service. Defaults to the $ServiceKey variable declared in the
    companion module scope.

    .EXAMPLE
    Resolve-RequestUrl -Path 'api/policies'

    Returns https://<subdomain>.sca.cyberark.cloud/api/policies when called from IdentityCommand.SCA.

    .OUTPUTS
    System.String
    #>
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [parameter(
            Mandatory = $false,
            Position = 0
        )]
        [AllowEmptyString()]
        [string]$Path,

        [parameter(Mandatory = $false)]
        [string]$Service = $Script:ServiceKey
    )

    process {

        $IDSession = Get-IDSession

        if (($null -eq $IDSession.StartTime) -and ($null -ne $ISPSSSession.StartTime)) {

            #The IdentityCommand session the module session was copied from has been closed
            foreach ($key in 'tenant_url', 'TenantId', 'WebSession', 'User', 'StartTime', 'SessionId', 'Subdomain') {
                $ISPSSSession[$key] = $null
            }

        }

        if (($null -ne $IDSession.StartTime) -and ($IDSession.StartTime -ne $ISPSSSession.StartTime)) {

            $ServiceUrl = if ($IDSession.Subdomain -eq $ISPSSSession.Subdomain) { $ISPSSSession.tenant_url }

            foreach ($key in $IDSession.keys) {
                $ISPSSSession[$key] = $IDSession[$key]
            }

            $ISPSSSession.tenant_url = $ServiceUrl

        }

        if ([string]::IsNullOrEmpty($ISPSSSession.tenant_url)) {

            if ($null -eq $IDSession.StartTime) {
                throw 'Authenticate with New-IDSession or New-IDPlatformToken, and try again'
            }

            if ([string]::IsNullOrEmpty($Service)) {
                throw 'No service specified to resolve the request URL for'
            }

            if ([string]::IsNullOrEmpty($ISPSSSession.Subdomain)) {
                throw "Unable to resolve the '$Service' service URL: the IdentityCommand session token does not include the shared services subdomain"
            }

            $ISPSSSession.tenant_url = (Resolve-ServiceUrl -Service $Service -Subdomain $ISPSSSession.Subdomain).ServiceUrl

        }

        if ([string]::IsNullOrEmpty($Path)) {
            $ISPSSSession.tenant_url
        } else {
            "$($ISPSSSession.tenant_url)/$($Path -replace '^/', '')"
        }

    }

}

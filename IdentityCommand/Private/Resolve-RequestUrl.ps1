function Resolve-RequestUrl {
    <#
    .SYNOPSIS
    Composes a companion module request URL, connecting the module to the IdentityCommand session on demand.

    .DESCRIPTION
    Used by the IdentityCommand.* companion modules, which copy this function into their own scope,
    so $ISPSSSession and the $Script: variables here are the companion module's own.

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

    A service URL the companion module sets itself (e.g. Set-SMAccessToken) is used as is.

    A companion module can declare these module scope variables to change the behaviour:

      - $ServiceKey: the platform discovery key of the service.
      - $ServiceEndpoint: the property of the service's discovery entry to read the service URL
        from, when not 'api' (CEM uses 'bootstrap').
      - $SessionConnectedHook: a scriptblock run after the module session is copied from the
        IdentityCommand session or its service URL is resolved, e.g. to exchange the session for a
        service specific token. If it fails, it runs again on the next request.
      - $IndependentSession: when $true, the module session is not synchronised with the
        IdentityCommand session, and is used as is.

    .PARAMETER Path
    The path of the operation under the service URL, with or without a leading forward slash.
    Any path parameter values must already be escaped by the caller.

    .PARAMETER Service
    The platform discovery key of the service. Defaults to the $ServiceKey variable declared in the
    companion module scope.

    .PARAMETER Endpoint
    The property of the service's discovery entry to read the service URL from. Defaults to the
    $ServiceEndpoint variable declared in the companion module scope, or 'api' if there is none.

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
        [string]$Service = $Script:ServiceKey,

        [parameter(Mandatory = $false)]
        [string]$Endpoint = $Script:ServiceEndpoint
    )

    process {

        $IDSession = Get-IDSession
        $Connected = $false

        if ($Script:IndependentSession -ne $true) {

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
                $Connected = $true

            }

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

            if ([string]::IsNullOrEmpty($Endpoint)) { $Endpoint = 'api' }

            $ISPSSSession.tenant_url = (Resolve-ServiceUrl -Service $Service -Subdomain $ISPSSSession.Subdomain -Endpoint $Endpoint).ServiceUrl

            $Connected = $true

        }

        if ($Connected -and ($Script:IndependentSession -ne $true) -and ($null -ne $Script:SessionConnectedHook)) {

            try {
                & $Script:SessionConnectedHook
            } catch {
                #Resolve the service URL and run the hook again on the next request
                $ISPSSSession.tenant_url = $null
                throw
            }

        }

        if ([string]::IsNullOrEmpty($Path)) {
            $ISPSSSession.tenant_url
        } else {
            "$($ISPSSSession.tenant_url)/$($Path -replace '^/', '')"
        }

    }

}

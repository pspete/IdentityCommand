function Resolve-ServiceUrl {
    <#
    .SYNOPSIS
    Resolves a service URL and the CyberArk Identity URL from platform discovery.

    .DESCRIPTION
    Given an ISPSS shared services subdomain, or a URL for one of the shared services, queries
    CyberArk platform discovery (via Find-SharedServicesURL) once and returns the URLs a companion
    module's Connect- command needs:

      - ServiceUrl  - the api URL of the requested service, with any trailing /api and trailing
                      slash removed, so a caller can append its own /<path> unconditionally.
      - IdentityUrl - the 'identity_user_portal' service api URL (the CyberArk Identity tenant URL
                      that New-IDSession / New-IDPlatformToken authenticate against).
      - ServicePath - the path discarded from the service URL by BaseUrlOnly, otherwise empty.

    When a URL is supplied, Find-SharedServicesURL derives the shared services subdomain from the
    first label of the host name - correct for the standard https://<subdomain>.<service>.cyberark.cloud
    URL form.

    Throws if the requested service is absent from the discovery response - a service which is not
    enabled on the tenant, or a mistyped key, would otherwise yield a null ServiceUrl and leave the
    calling Connect- command holding a session bound to no URL at all.

    .PARAMETER Service
    The platform discovery key of the service to resolve, for example 'sca' or 'jit'.

    .PARAMETER Subdomain
    The ISPSS shared services subdomain.

    .PARAMETER Url
    A service URL to derive the shared services subdomain from.

    .PARAMETER BaseUrlOnly
    Return only the scheme and host of the service URL, with any path reported separately as
    ServicePath. Needed by services which publish a path along with the host - 'alerong' (Remote
    Access) publishes https://api.alero.io/internal/ra/v1/<tenantId>, where the API base URL is the
    host and the trailing segment is the tenant id.

    .EXAMPLE
    Resolve-ServiceUrl -Service sca -Subdomain sometenant

    .EXAMPLE
    Resolve-ServiceUrl -Service jit -Url https://sometenant.dpa.cyberark.cloud
    #>
    [OutputType([pscustomobject])]
    [CmdletBinding(DefaultParameterSetName = 'Subdomain')]
    param(
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Service,

        [parameter(Mandatory = $true, ParameterSetName = 'Subdomain')]
        [ValidateNotNullOrEmpty()]
        [string]$Subdomain,

        [parameter(Mandatory = $true, ParameterSetName = 'URL')]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [parameter(Mandatory = $false)]
        [switch]$BaseUrlOnly
    )

    $Reference = if ($PSCmdlet.ParameterSetName -eq 'Subdomain') { $Subdomain } else { $Url }

    try {

        $Discovery = if ($PSCmdlet.ParameterSetName -eq 'Subdomain') {
            Find-SharedServicesURL -subdomain $Subdomain
        } else {
            Find-SharedServicesURL -url $Url
        }

    } catch {

        throw "Unable to resolve CyberArk shared services URLs from '$Reference': $($PSItem.Exception.Message)"

    }

    $IdentityUrl = $Discovery.identity_user_portal.api -replace '/$', ''

    if ([string]::IsNullOrEmpty($IdentityUrl)) {
        throw "CyberArk Identity URL (identity_user_portal) not found in platform discovery response for '$Reference'"
    }

    $ServiceApi = $Discovery.$Service.api
    $ServicePath = ''

    if ($BaseUrlOnly -and (-not [string]::IsNullOrEmpty($ServiceApi))) {

        $Builder = [System.UriBuilder]::new($ServiceApi)
        $ServiceHost = $Builder.Host
        $ServicePath = $Builder.Path -replace '/$', ''

        #alerong has been observed publishing the host and path concatenated without their separating
        #slash - https://api.alero.iointernal/ra/v1/<tenantId> - which a plain parse reads as the host
        #'api.alero.iointernal'. Recover the authority at the TLD boundary and hand the leaked text
        #back to the path. The path charset excludes a dot, so a legitimate host cannot match.
        if ($ServiceHost -match '^(?<hostname>.+\.(?:io|com|cloud|net))(?<leaked>[a-z0-9-]+)$') {

            Write-Verbose "Discovery returned a malformed URL for '$Service': recovered host '$($Matches['hostname'])' from '$ServiceHost'"
            $ServicePath = "/$($Matches['leaked'])$ServicePath"
            $ServiceHost = $Matches['hostname']

        }

        $Builder.Host = $ServiceHost
        $Builder.Path = ''
        $ServiceUrl = $Builder.Uri.AbsoluteUri -replace '/$', ''

    } else {

        #Strip a trailing /api, then any trailing slash: services vary in whether they publish either,
        #and callers always append their own /<path>. cem and cds publish a bare host with a trailing slash.
        $ServiceUrl = $ServiceApi -replace '/api/?$', '' -replace '/$', ''

    }

    if ([string]::IsNullOrEmpty($ServiceUrl)) {
        throw "URL for the '$Service' service not found in platform discovery response for '$Reference'. The service may not be enabled on this tenant"
    }

    [pscustomobject]@{
        ServiceUrl  = $ServiceUrl
        IdentityUrl = $IdentityUrl
        ServicePath = $ServicePath
    }

}

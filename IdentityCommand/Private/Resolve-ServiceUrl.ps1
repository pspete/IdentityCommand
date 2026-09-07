function Resolve-ServiceUrl {
    <#
    .SYNOPSIS
    Resolves a service URL and the CyberArk Identity URL from platform discovery.

    .DESCRIPTION
    Given an ISPSS shared services subdomain, or a URL for one of the shared services, queries
    CyberArk platform discovery (via Find-SharedServicesURL) once and returns the URLs a companion
    module's Connect- command needs:

      - ServiceUrl  - the api URL of the requested service, with any trailing /api removed.
      - IdentityUrl - the 'identity_user_portal' service api URL (the CyberArk Identity tenant URL
                      that New-IDSession / New-IDPlatformToken authenticate against).

    When a URL is supplied, Find-SharedServicesURL derives the shared services subdomain from the
    first label of the host name - correct for the standard https://<subdomain>.<service>.cyberark.cloud
    URL form.

    .PARAMETER Service
    The platform discovery key of the service to resolve, for example 'sca' or 'jit'.

    .PARAMETER Subdomain
    The ISPSS shared services subdomain.

    .PARAMETER Url
    A service URL to derive the shared services subdomain from.

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
        [string]$Url
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

    [pscustomobject]@{
        ServiceUrl  = $Discovery.$Service.api -replace '/api/?$', ''
        IdentityUrl = $IdentityUrl
    }

}

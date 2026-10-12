function ConvertFrom-JwtPayload {
    <#
    .SYNOPSIS
    Returns the claims from the payload of a JSON Web Token.

    .DESCRIPTION
    Decodes the base64url payload segment of a JWT and returns its claims as an object.
    The signature is not validated: use the result only to read values from a token the
    module already holds, never to make trust decisions.

    Accepts a raw token, or an Authorization header value with a scheme prefix (Bearer <jwt>).

    .PARAMETER Token
    The JWT, or an Authorization header value containing one.

    .EXAMPLE
    ConvertFrom-JwtPayload -Token $Token

    .EXAMPLE
    ConvertFrom-JwtPayload -Token $ISPSSSession.WebSession.Headers['Authorization']
    #>
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [parameter(
            Mandatory = $true,
            ValueFromPipeline = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Token
    )

    process {

        $Segments = ($Token -replace '^\S+\s+', '').Split('.')

        if ($Segments.Count -ne 3) {
            throw 'Token is not a JWT'
        }

        $Payload = $Segments[1].Replace('-', '+').Replace('_', '/')

        switch ($Payload.Length % 4) {
            2 { $Payload += '==' }
            3 { $Payload += '=' }
        }

        [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Payload)) | ConvertFrom-Json

    }

}

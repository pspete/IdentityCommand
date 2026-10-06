---
title: Authentication
subtitle: Sign in to an Idira Identity tenant
---

Once authenticated, every IdentityCommand command that requires a session - and every sibling `IdentityCommand.*` module - can be used from within the same PowerShell session.

## Identity user authentication

Initiate authentication to a tenant with [`New-IDSession`]({{ '/commands/New-IDSession/' | relative_url }}):

```powershell
PS C:\> $Credential = Get-Credential
PS C:\> New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
```

Initial authentication progresses through selection and answer of any required MFA challenges, including out-of-band and SAML-based flows.

## Service user authentication

Service user credentials can be used to request an authentication token for the Identity platform with [`New-IDPlatformToken`]({{ '/commands/New-IDPlatformToken/' | relative_url }}):

```powershell
PS C:\> $Credential = Get-Credential
PS C:\> New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
```

This allows authentication using a separate, dedicated service user for API activities.
Consult the vendor documentation for guidance on setting up a dedicated API service user for non-interactive use.

## Session methods

The object returned on successful authentication has methods for obtaining authenticated session data and tokens - useful for APIs not yet covered by module commands.

### GetToken

Returns a bearer token header for further requests:

```powershell
PS C:\> $Session = New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
PS C:\> $Session.GetToken()

Name                           Value
----                           -----
Authorization                  Bearer eyPhbSciPiJEUzT1NEIsInR5cCI6IkpXYZ...
```

### GetWebSession

Returns the WebSession object for the authenticated session:

```powershell
PS C:\> $Session = New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
PS C:\> $Session.GetWebSession()

Headers               : {[accept, */*], [X-IDAP-NATIVE-CLIENT, True]}
Cookies               : System.Net.CookieContainer
UseDefaultCredentials : False
Credentials           :
Certificates          :
UserAgent             : Mozilla/5.0 (Windows NT; Windows NT 10.0; en-GB) WindowsPowerShell/5.1.22621.1778
Proxy                 :
MaximumRedirection    : -1
```

The WebSession can be used for any further requests you require:

```powershell
PS C:\> $WebSession = $Session.GetWebSession()
PS C:\> Invoke-RestMethod -WebSession $WebSession `
-Method Post `
-Uri https://sometenant.id.cyberark.cloud/Some/Endpoint `
-Body (@{SomeProperty = 'SomeValue'} | ConvertTo-Json)
```

## Session data

[`Get-IDSession`]({{ '/commands/Get-IDSession/' | relative_url }}) returns data from the module scope:

```powershell
PS C:\> Get-IDSession

Name                           Value
----                           -----
tenant_url                     https://abc1234.id.cyberark.cloud
User                           some.user@somedomain.com
TenantId                       ABC1234
SessionId                      1337CbGbPunk3Sm1ff5ess510nD3tai75
WebSession                     Microsoft.PowerShell.Commands.WebRequestSession
StartTime                      12/02/2024 22:58:13
ElapsedTime                    00:25:30
LastCommand                    System.Management.Automation.InvocationInfo
LastCommandTime                12/02/2024 23:23:07
LastCommandResults             {"success":true,"Result":{"SomeResult"}}
```

This exposes the URL, username & WebSession for the authenticated session, either for use in requests outside of the module or for information.
It also includes the session start time, elapsed time, last command time, and data for the last invoked command and its results.

## Ending a session

[`Close-IDSession`]({{ '/commands/Close-IDSession/' | relative_url }}) logs off and clears the module session data.

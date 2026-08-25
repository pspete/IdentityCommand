![Logo][Logo]

[Logo]: /docs/media/images/IdentityCommand.png

# IdentityCommand

IdentityCommand is a PowerShell module that wraps the REST API for a Palo Alto Idira (formerly CyberArk) Identity tenant, giving you easy-to-use commands for authentication (including MFA/SAML/OIDC flows) and administration - users, roles, applications, organizations, authentication policies, SCIM provisioning, and more - all from within PowerShell.

The module has been in development for a few years, initially focused on authentication. Coverage is expanding significantly to reach near-complete coverage of the Identity Administration API, and IdentityCommand is also the foundation for a growing family of other `pspete` modules that administer the wider Idira SaaS platform - e.g. `IdentityCommand.DPA`, which builds on IdentityCommand's authentication to administer Idira DPA.

- **Prior to a Version 1.0.0 release**:
  - Expect changes
  - Things may break
  - Issues / PRs are encouraged & appreciated
  - Many commands are built from documented API shapes but not yet exercised against a live tenant - see [Help Us Test](#help-us-test) below, your feedback genuinely shapes what ships next.

---

## Project Objective

- To develop & publish consistently coded PowerShell functions for available Idira (CyberArk) Identity APIs.

## Use Cases

The current main use cases of the project are focused on authentication to the Idira (CyberArk) Identity platform.

### Identity User Authentication

An example command to initiate authentication to a specified tenant is shown here:

```powershell
PS C:\> $Credential = Get-Credential
PS C:\> New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
```

This allows initial authentication to progress as well as selection and answer of any required MFA challenges.

Once successfully authenticated, all _IdentityCommand_ module commands which require an authenticated session can be used from within the same PowerShell session.

### Service User Authentication

Service User credentials can be used to request an authentication token for the Identity Platform:

```powershell
PS C:\> $Credential = Get-Credential
PS C:\> New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
```

This allows initial authentication using a separate dedicated Service user for API activities.

Consult the vendor documentation for guidance on setting up a dedicated API Service user for non-interactive API use.

Once successfully authenticated, all _IdentityCommand_ module commands which require an authenticated session can be used from within the same PowerShell session.

### Methods

IdentityCommand authentication functions contain methods which can be used to obtain authenticated session data & authentication tokens:

#### GetToken Method

You may have a scenario where you want to use APIs for which we have not yet developed, built or published module commands.

The GetToken method of the object returned on successful authentication can be invoked to obtain a bearer token to be used for further requests.

```powershell
PS C:\> $Session = New-IDPlatformToken -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
PS C:\> $Session.GetToken()

Name                           Value
----                           -----
Authorization                  Bearer eyPhbSciPiJEUzT1NEIsInR5cCI6IkpXYZ...
```

#### GetWebSession Method

The GetWebSession method can be used in a similar way to GetToken, except this method returns the websession object for the authenticated session instead of a Bearer token.

```powershell
PS C:\> $Session = New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
PS C:\> $session.GetWebSession()

Headers               : {[accept, */*], [X-IDAP-NATIVE-CLIENT, True]}
Cookies               : System.Net.CookieContainer
UseDefaultCredentials : False
Credentials           :
Certificates          :
UserAgent             : Mozilla/5.0 (Windows NT; Windows NT 10.0; en-GB) WindowsPowerShell/5.1.22621.1778
Proxy                 :
MaximumRedirection    : -1
```

The Websession can be used for any further requests you require.

```powershell
PS C:\> $Websession = $session.GetWebSession()
PS C:\> Invoke-RestMethod -WebSession $websession `
-Method Post `
-Uri https://somedomain .id.cyberark.cloud `
-Body @{SomeProperty = 'SomeValue'} | ConvertTo-Json
```

### Module Scope Variables & Command Invocation Data

The `Get-IDSession` command can be used to return data from the module scope:

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

Executing this command exports variables like the URL, Username & WebSession object for the authenticated session from IdentityCommand into your local scope, either for use in other requests outside of the module scope, or for informational purposes.

Return data also includes details such as session start time, elapsed time, last command time, as well as data for the last invoked command and the results of the previous command.

## List Of Commands

_IdentityCommand_ currently ships 170+ commands, grouped into the areas below. The full list moves fast enough that it's not reproduced command-by-command here - instead, once the module is imported:

```powershell
# List every command in the module, grouped by area
Get-Command -Module IdentityCommand | Group-Object { $_.Name.Split('-')[1] -replace '^ID' }

# Get detailed help, including examples, for any command
Get-Help Get-IDUser -Full
```

Every command also has a corresponding reference page under [`docs/collections/_commands`](docs/collections/_commands), which is the same content `Get-Help` displays.

| Area | Covers |
| --- | --- |
| **Session / Authentication** | Interactive & service-account sign-in (credential, SAML, MFA challenges), session lifecycle, platform tokens |
| **Users** | User CRUD, roles, attributes, security questions, U2F devices, sessions, invites, identity verification, password/lock management |
| **Roles** | Roles, membership (users/roles/groups), administrative permissions, dynamic role scripts |
| **Applications** | Application catalog CRUD, permissions, tags, icons, personal apps & secured items, CSV import |
| **Organizations** | Organization/tenant-partition administration, membership, administrators, permissions |
| **Policies** | Authentication profiles & policies, MFA assurance levels, OTP/password complexity settings |
| **SCIM** | SCIM-based provisioning for users, groups, containers, container permissions & privileged data |
| **Tenant** | Tenant configuration, cnames, suffixes, security questions, message templates |
| **Workflow** | Access-request workflow jobs and approval/denial events |
| **Devices** | Device registration & management |
| **Core** | Lower-level helpers - ad-hoc SQL queries, permission lookups, download URLs, password generation |

## Help Us Test

Prior to a 1.0.0 release, some commands are built from documented or captured API shapes but haven't yet been exercised against a live tenant, or only partially confirmed. If you're able to try one of these against your own tenant, [open an issue][new-issue] with what you found (works as-is, needs a fix, or the request shape is wrong) - it's genuinely the fastest way to move a command from "should work" to "confirmed".

The current list is:

| Command | What's unconfirmed |
| --- | --- |
| `Stop-IDWorkflowJob` | Needs a real Task ID (a distinct ID space from the `WorkFlowJob` IDs `Get-IDWorkflowJob` returns) - unclear what produces one |
| `Set-IDOrganizationPermission` | `Right`'s real values are unknown; a guess was rejected server-side |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- an Idira (CyberArk) Identity tenant
- An Account to Access Idira (CyberArk) Identity

### Install Options

Users can install IdentityCommand from GitHub or the PowerShell Gallery.

Choose any of the following ways to download the module and install it:

#### Option 1: Install from PowerShell Gallery

This is the easiest and most popular way to install the module:

1. Open a PowerShell prompt

2. Run the following command:

```powershell
Install-Module -Name IdentityCommand -Scope CurrentUser
```

#### Option 2: Manual Install

The module files can be manually copied to one of your PowerShell module directories.

Use the following command to get the paths to your local PowerShell module folders:

```powershell

$env:PSModulePath.split(';')

```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand`.

More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

##### PowerShell Gallery

- Download from the module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/IdentityCommand/):
  - Run the PowerShell command `Save-Module -Name IdentityCommand -Path C:\temp`
  - Copy the `C:\temp\IdentityCommand` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand Release

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand/releases/latest)
  - Unblock & Extract the archive
  - Rename the extracted `IdentityCommand-v#.#.#` folder to `IdentityCommand`
  - Copy the `IdentityCommand` folder to your "Powershell Modules" directory of choice.

##### IdentityCommand Branch

- [Download the `main` branch](https://github.com/pspete/IdentityCommand/archive/refs/heads/main.zip)
  - Unblock & Extract the archive
  - Copy the `IdentityCommand` (`\<Archive Root>\IdentityCommand-master\IdentityCommand`) folder to your "Powershell Modules" directory of choice.

#### Verification

Validate Install:

```powershell

Get-Module -ListAvailable IdentityCommand

```

Import the module:

```powershell

Import-Module IdentityCommand

```

List Module Commands:

```powershell

Get-Command -Module IdentityCommand

```

Get detailed information on specific commands:

```powershell

Get-Help New-IDSession -Full

```

## Sponsorship

Please support continued development; consider sponsoring <a href="https://github.com/sponsors/pspete"> @pspete on GitHub Sponsors</a>

## Changelog

All notable changes to this project will be documented in the [Changelog](CHANGELOG.md)

## Author

- **Pete Maan** - [pspete](https://github.com/pspete)

## License

This project is [licensed under the MIT License](LICENSE.md).

## Contributing

Any and all contributions to this project are appreciated.

See the [CONTRIBUTING.md](CONTRIBUTING.md) for a few more details.

## Support

_IdentityCommand_ is neither developed nor supported by Palo Alto / CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.

![Logo][Logo]

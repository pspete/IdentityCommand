![Logo][Logo]

[Logo]:/docs/media/images/IdentityCommand.png

# IdentityCommand

IdentityCommand [Work in Progress] is a PowerShell module that provides a set of easy-to-use commands, allowing you to interact with the API for a CyberArk Identity tenant from within the PowerShell environment.

- **Prior to a Version 1.0.0 release**:
  - Expect changes
  - Things may break
  - Issues / PRs are encouraged & appreciated

----------

## Project Objective

- To develop & publish consistently coded PowerShell functions for available CyberArk Identity APIs.

## Use Cases

The current main use cases of the project are focused on authentication to the CyberArk Identity platform.

### Identity User Authentication

An example command to initiate authentication to a specified tenant is shown here:

```powershell
PS C:\> $Credential = Get-Credential
PS C:\> New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential $Credential
```

This allows initial authentication to progress as well as selection and answer of any required MFA challenges.

Once successfully authenticated, all _IdentityCommand_ module commands which require an authenticated session can be used from within the same PowerShell session.


#### GetBearerToken Method

You may have a scenario where you want to use APIs for which we have not yet developed, built or published module commands.

The GetBearerToken method of the object returned on successful authentication can be invoked to obtain a bearer token to be used for further requests.

```powershell
PS C:\> $Session = New-IDSession -tenant_url https://some.tenant.cyberark.cloud -Credential $Credential
PS C:\> $Session.GetBearerToken()

Name                           Value
----                           -----
Authorization                  Bearer eyPhbSciPiJEUzT1NEIsInR5cCI6IkpXYZ...
```

#### GetWebSession Method

The GetWebSession method can be used in a similar way to GetBearerToken, but the websession object for the authenticated session is returned instead of a Bearer token.

```powershell
PS C:\> $Session = New-IDSession -tenant_url https://some.tenant.cyberark.cloud -Credential $Credential
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
-Uri https://somedomain.id.cyberark.cloud `
-Body @{SomeProperty = 'SomeValue'} | ConvertTo-Json
```

## List Of Commands

The commands currently available in the _IdentityCommand_ module are listed here:

| Function                   | Description                                                                                 |
|----------------------------|---------------------------------------------------------------------------------------------|
| `New-IDSession`            | Authenticate to CyberArk Identity, answering MFA challenges to start a new API session.     |
| `Close-IDSession`          | Logoff CyberArk Identity API                                                                |
| `Clear-IDUserSession`      | Signs out user from all active sessions                                                     |
| `Get-IDWebSession`         | Get WebSession object from the module scope                                                 |
| `Get-IDUser`               | Fetch details of cloud directory users                                                      |
| `Suspend-IDUserMFA`        | Exempt a user from MFA                                                                      |
| `Test-IDUserCloudLock`     | Checks if a user is cloud locked                                                            |
| `Lock-IDUserCloudLock`     | Enable user cloud lock                                                                      |
| `Unlock-IDUserCloudLock`   | Disable user cloud lock                                                                     |
| `Get-IDTenant`              | Get tenant information                                                                      |
| `Get-IDTenantConfiguration` | Get tenant configuration data                                                               |

## Installation

### Prerequisites

- Requires Powershell Core (recommended), or Windows PowerShell (version 5.1)
- A CyberArk Identity tenant
- An Account to Access CyberArk Identity

### Install Options

This repository contains a folder named ```IdentityCommand```.

The folder needs to be copied to one of your PowerShell Module Directories.

#### Manual Install

Find your PowerShell Module Paths with the following command:

```powershell
$env:PSModulePath.split(';')
```

[Download the ```dev``` branch](https://github.com/pspete/IdentityCommand/archive/dev.zip)

Unblock & Extract the archive

Copy the ```IdentityCommand``` folder to your "Powershell Modules" directory of choice.

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

_IdentityCommand_ is neither developed nor supported by CyberArk; any official support channels offered by the vendor are not appropriate for seeking help with the _IdentityCommand_ module.

Help and support should be sought by [opening an issue][new-issue].

[new-issue]: https://github.com/pspete/IdentityCommand/issues/new

Priority support could be considered for <a href="https://github.com/sponsors/pspete">sponsors of @pspete</a>, <a href="mailto:pspete@pspete.dev">contact us</a> to discuss options.

![Logo][Logo]
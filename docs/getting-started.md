---
title: Getting Started
subtitle: Install IdentityCommand and run your first commands
---

## Prerequisites

- PowerShell 7 (recommended), or Windows PowerShell 5.1
- An Idira (CyberArk) Identity tenant
- An account to access Idira (CyberArk) Identity

## Install from the PowerShell Gallery

This is the easiest and most popular way to install the module:

```powershell
Install-Module -Name IdentityCommand -Scope CurrentUser
```

## Manual install

The module files can be manually copied to one of your PowerShell module directories.
List them with:

```powershell
$env:PSModulePath.split(';')
```

The module files must be placed in one of the listed directories, in a folder called `IdentityCommand`.
More: [about_PSModulePath](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_psmodulepath)

The module files are available to download using a variety of methods:

**PowerShell Gallery**

- Run `Save-Module -Name IdentityCommand -Path C:\temp`
- Copy the `C:\temp\IdentityCommand` folder to your PowerShell modules directory of choice.

**GitHub release**

- [Download the latest GitHub release](https://github.com/pspete/IdentityCommand/releases/latest)
- Unblock & extract the archive
- Rename the extracted `IdentityCommand-v#.#.#` folder to `IdentityCommand`
- Copy the `IdentityCommand` folder to your PowerShell modules directory of choice.

**GitHub branch**

- [Download the `main` branch](https://github.com/pspete/IdentityCommand/archive/refs/heads/main.zip)
- Unblock & extract the archive
- Copy the `IdentityCommand` (`<Archive Root>\IdentityCommand-main\IdentityCommand`) folder to your PowerShell modules directory of choice.

## Verify

```powershell
# Validate install
Get-Module -ListAvailable IdentityCommand

# Import the module
Import-Module IdentityCommand

# List every command, grouped by area
Get-Command -Module IdentityCommand | Group-Object { $_.Name.Split('-')[1] -replace '^ID' }

# Detailed help, including examples, for any command
Get-Help New-IDSession -Full
```

Every command has a page in the [command reference]({{ '/commands/' | relative_url }}) - the same content `Get-Help` displays.

## Next steps

- [Authenticate]({{ '/authentication/' | relative_url }}) to your tenant with `New-IDSession` or `New-IDPlatformToken`.
- Add a sibling module, such as [IdentityCommand.SCA]({{ '/SCA/' | relative_url }}) or [IdentityCommand.SIA]({{ '/SIA/' | relative_url }}), to administer other Idira services using the same session.

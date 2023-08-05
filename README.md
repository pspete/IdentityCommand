![Logo][Logo]

[Logo]:/docs/media/images/IdentityCommand.png

# IdentityCommand

IdentityCommand [Work in Progress] is a PowerShell module that enables you to send and receive data from the API for the CyberArk Identity platform.

This module provides a set of easy-to-use commands that allow you to interact with a CyberArk Identity tenant from within the PowerShell environment.

- **Prior to a Version 1.0.0 release**:
  - Expect changes
  - Things may break
  - Issues / PRs are encouraged & appreciated

----------

## Project Objective

To develop & publish PowerShell functions for available CyberArk Identity APIs.

## List Of Commands

| Function                   | Description                                                                                 |
|----------------------------|---------------------------------------------------------------------------------------------|
| New-IDSession              | Authenticate to CyberArk Identity, answering MFA challenges to start a new API session.     |
| Close-IDSession            | Logoff CyberArk Identity API                                                                |
| Get-IDCurrentUser          | Get details of authenticated user                                                           |
| Clear-IDUserSession        | Signs out user from all active sessions                                                     |
| Get-IDWebSession           | Get WebSession object from the module scope                                                 |

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

![Logo][Logo]
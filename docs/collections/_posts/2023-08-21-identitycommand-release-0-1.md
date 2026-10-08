---
title: "IdentityCommand Release 0.1"
date: 2023-10-08 00:00:00
version: 0.1.43
tags:
  - Release Notes
  - New-IDSession
  - Close-IDSession
  - Clear-IDUserSession
  - Get-IDSession
  - Get-IDUser
  - Suspend-IDUserMFA
  - Test-IDUserCloudLock
  - Lock-IDUser
  - Unlock-IDUser
  - Get-IDTenant
  - Get-IDTenantConfiguration
  - Get-IDConnector
  - New-IDPlatformToken
  - Get-IDUserRole
  - Get-IDTenantCname
  - Get-IDDownloadUrl
  - Get-IDUserIdentifier
  - Invoke-IDSqlcmd
---

## [0.1.43]

### Changed

- `New-IDSession` - Moves ScriptMethod declaration into code body from `\xml\IdCmd.ID.Session.Types.ps1xml`.

### Fixed

- Replaces `[Environment]::GetEnvironmentVariable(`Temp`)` with `[System.IO.Path]::GetTempPath()` to correctly determine %TEMP% directory location on Windows as well as OSX.

## [0.1.39]

### Changed

- `New-IDSession` - Adds federated authentication support, with ability to provide a SamlResponse from an external IDP

## [0.1.34]

Additional Functions

### Added

- `Get-IDUserRole` - Get a list of roles for a user
- `Get-IDAnalyticsDataset` - Get all datasets accessible by a user
- `Get-IDTenantCname` - Get Tenant Cnames
- `Get-IDDownloadUrl` - Get download Urls
- `Get-IDUserIdentifier` - Get the configuration of the user attributes
- `Invoke-IDSqlcmd` - Query the database tables

## [0.1.29]

Initial module development prior to main release

### Added

- `New-IDSession` - Authenticate to CyberArk Identity, answering MFA challenges to start a new API session.
- `Close-IDSession` - Logoff CyberArk Identity API
- `Clear-IDUserSession` - Signs out user from all active sessions
- `Get-IDSession` - Get WebSession object from the module scope
- `Get-IDUser` - Fetch details of cloud directory users
- `Suspend-IDUserMFA` - Exempt a user from MFA
- `Test-IDUserCloudLock` - Checks if a user is cloud locked
- `Lock-IDUser` - Enable user cloud lock
- `Unlock-IDUser` - Disable user cloud locked
- `Get-IDTenant` - Get Tenant information
- `Get-IDTenantConfiguration` - Get tenant configuration data
- `Get-IDConnector` - Get connector health
- `New-IDPlatformToken` - Request OIDC token based on grant type

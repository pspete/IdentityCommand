# Change Log
All notable changes to this project will be documented in this file.

## [Unreleased] - 2023-08-11

Initial module development prior to main release

### Added
- `New-IDSession` - Authenticate to CyberArk Identity, answering MFA challenges to start a new API session.
- `Close-IDSession` - Logoff CyberArk Identity API
- `Clear-IDUserSession` - Signs out user from all active sessions
- `Get-IDWebSession` - Get WebSession object from the module scope
- `Get-IDUser` - Fetch details of cloud directory users
- `Suspend-IDUserMFA` - Exempt a user from MFA
- `Test-IDUserCloudLock` - Checks if a user is cloud locked
- `Lock-IDUserCloudLock` - Enable user cloud lock
- `Unlock-IDUserCloudLock` - Disable user cloud locked
- `Get-IDTenant` - Get Tenant information
- `Get-IDTenantConfiguration` - Get tenant configuration data

### Changed

### Fixed


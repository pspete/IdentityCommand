# Change Log
All notable changes to this project will be documented in this file.

## [unreleased] - ####-##-##

### Added
- N/A

### Changed
- N/A

### Fixed
- N/A

## [0.2 - Update 3] - 2024-03-03

### Added
- `Find-SharedServicesURL`
  - New helper function that can be used to find URLs for ISPSS services under a tenant

### Changed
- `ConvertTo-QueryString`
  - Updates helper function to implement functionality required in `Get-DPAStrongAccount` function of the `IdentityCommand.DPA` module.
  - If multiple values are accepted and provided for a value, return all values joined, delimited by a comma.

### Fixed
- N/A

## [0.2 - Update 2] - 2024-02-19

### Added
- N/A

### Changed
- N/A

### Fixed
- `Invoke-IDRestMethod`
  - Fixes a variable declaration which prevented certain error conditions from being reported.
  - Updated to report more errors recieved in various formats from Identity and also DPA.

## [0.2 - Update 1] - 2024-02-18

### Added
- N/A

### Changed
- `New-IDSession`
  - Adds `Authorization` header with Bearer token to WebSession object.
- `New-IDPlatformToken`
  - Adds `Authorization` header with Bearer token to WebSession object.
  - Updates values in script scope object in-line with the previous module update.
- Internal Functions & Error Handling
  - Adds additional logic to handle error messages from Identity and other ISPSS services.
  - Adds `LastError` details to script scope variable object returned with `Get-IDSession`.
  - Makes contentType matching less stringent to accommodate data returned from other ISPSS services.

### Fixed
- `New-IDPlatformToken`
  - Updated `GetWebSession` method to utilise `Get-IDSession` in order to return the WebSession object from the module's script scope.


## [0.2] - 2024-02-13

Updates the `Get-IDSession` command, which can be used to return data from the module scope:

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

Return data also includes details such as session start time, elapsed time, last command time, as well as data for the last invoked command and the results of the previous command useful for debugging & development purposes.

### Added
- Private Function `Get-ParentFunction`
  - Helper function to get command invocation data from different scopes
- Private Function `Get-SessionClone`
  - Helper function to create unreferenced copy of IdentityCommand session hashtable object

### Changed
- `Get-IDSession`
  - Returns the module scoped `$ISPSSSession` variable (which includes the WebSession object), instead of just the WebSession object.
- `New-IDSession`
  - Sets values in the script scope `$ISPSSSession` object instead of individual script scope variables.
- `Close-IDSession`
  - Sets null values in the script scope `$ISPSSSession` object instead of removing individual script scope variables.
- All other functions
  - Updated entire codebase to reference `$ISPSSSession` object instead of individual script scope variables.

### Fixed
- N/A

## [0.1 - Update 3] - 2023-10-08

### Added
- N/A

### Changed
- `New-IDSession` - Moves ScriptMethod declaration into code body from `\xml\IdCmd.ID.Session.Types.ps1xml`.

### Fixed
- Replaces `[Environment]::GetEnvironmentVariable('Temp')` with `[System.IO.Path]::GetTempPath()` to correctly determine %TEMP% directory location on Windows as well as OSX.

## [0.1 - Update 2] - 2023-09-19

### Added
- N/A

### Changed
- `New-IDSession` - Adds federated authentication support, with ability to provide a SamlResponse from an external IDP

### Fixed
- N/A

## [0.1 - Update 1] - 2023-08-30

Additional Functions

### Added
- `Get-IDUserRole` - Get a list of roles for a user
- `Get-IDAnalyticsDataset` - Get all datasets accessible by a user
- `Get-IDTenantCname` - Get Tenant Cnames
- `Get-IDDownloadUrl` - Get download Urls
- `Get-IDUserIdentifier` - Get the configuration of the user attributes
- `Invoke-IDSqlcmd` - Query the database tables

### Changed
- N/A

### Fixed
- N/A

## [0.1] - 2023-08-21

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

### Changed
- N/A

### Fixed
- N/A

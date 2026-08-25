# Change Log

All notable changes to this project will be documented in this file.

## [unreleased] - ####-##-##

### Added

- N/A

### Changed

- N/A

### Fixed

- N/A

## [0.5] - 2026-08-25

Major expansion of Identity Administration API coverage - 113 new commands across
Applications, Organizations, SCIM, Users, Workflow, Devices and Tenant.

### Added

- Applications
  - `Get-IDApplication`, `New-IDApplication`, `Set-IDApplication`, `Remove-IDApplication`, `Copy-IDApplication`
  - `Get-IDApplicationData`, `Get-IDApplicationForUser`, `Get-IDApplicationTemplate`, `Import-IDApplicationTemplate`
  - `Get-IDApplicationPermission`, `Set-IDApplicationPermission`
  - `Get-IDApplicationTag`, `New-IDApplicationTag`, `Set-IDApplicationTag`, `Rename-IDApplicationTag`, `Remove-IDApplicationTag`
  - `Set-IDApplicationIcon`, `Set-IDApplicationUserCredential`
  - `Get-IDSecuredItem`, `New-IDSecuredItem`, `Set-IDSecuredItemIcon`, `Set-IDSecuredItemTag`, `Update-IDSecuredItemCredential`
  - `Get-IDPersonalApplicationImportFile`, `Get-IDPersonalApplicationImportLog`, `Import-IDPersonalApplicationCsv`
  - `Get-IDUserPortalData`, `Get-IDCredentialProvider`, `Move-IDUserOwnership`
  - `Test-IDApplicationCatalogAvailability`, `Test-IDApplicationUsername`
  - `Update-IDCapturedUserApplication`, `Update-IDPersonalUserApplication`, `Update-IDUserApplication`
- Organizations
  - `Get-IDOrganization`, `New-IDOrganization`, `Set-IDOrganization`, `Remove-IDOrganization`
  - `Get-IDOrganizationAdministrator`, `Set-IDOrganizationAdministrator`
  - `Get-IDOrganizationMember`, `Get-IDOrganizationPermission`, `Get-IDOrganizationRole`, `Set-IDOrganizationMembership`
- SCIM provisioning (Users, Groups, Containers, Container Permissions, Privileged Data)
  - `Get-`/`New-`/`Set-`/`Update-`/`Remove-IDSCIMUser`
  - `Get-`/`New-`/`Set-`/`Update-`/`Remove-IDSCIMGroup`
  - `Get-`/`New-`/`Set-`/`Remove-IDSCIMContainer`
  - `Get-`/`New-`/`Set-`/`Remove-IDSCIMContainerPermission`
  - `Get-`/`New-`/`Set-`/`Remove-IDSCIMPrivilegedData`
  - `Get-IDSCIMResourceType`, `Get-IDSCIMSchema`, `Get-IDSCIMServiceProviderConfig`
- Users
  - `New-IDUser`, `Set-IDUser`, `Remove-IDUser`, `Enable-IDUser`, `Disable-IDUser`, `Import-IDUserCsv`
  - `Set-IDUserPassword`, `Set-IDUserPhonePin`, `Set-IDUserPicture`
  - `Get-IDUserAttribute`, `Set-IDUserAttribute`, `Get-IDUserHierarchy`, `Get-IDUserInfo`, `Get-IDUserRiskLevel`
  - `Get-IDUserSecurityQuestion`, `Set-IDUserSecurityQuestion`, `Reset-IDUserSecurityQuestion`
  - `Get-IDUserU2FDevice`, `Get-IDUserU2FRegistrationChallenge`, `Complete-IDUserU2FRegistrationChallenge`, `Remove-IDUserU2FDevice`
  - `Close-IDUserSession`, `Send-IDUserIdentityVerification`, `Send-IDUserInvite`, `Send-IDUserLoginEmail`
  - `Sync-IDUserOathToken`, `Test-IDUserLockedOutByPolicy`
- Workflow
  - `Get-IDWorkflowJob`, `Get-IDWorkflowJobReport`, `Start-IDWorkflowJob`, `Remove-IDWorkflowJob`, `Send-IDWorkflowEvent`
- Devices
  - `New-IDDevice`, `Remove-IDDevice`, `Unregister-IDDevice`
- Tenant
  - `Get-IDTenantConfigEntry`, `Set-IDTenantConfigEntry`, `Remove-IDTenantConfigEntry`, `Set-IDTenantConfiguration`
  - `Get-IDTenantMessageTemplate`
  - `Get-IDTenantSecurityQuestion`, `Set-IDTenantSecurityQuestion`, `Remove-IDTenantSecurityQuestion`
- `New-IDPassword` - generates a password for a user

### Changed

- `Invoke-IDRestMethod`
  - Any request body carrying a decoded password/secret is now sent as raw UTF8 bytes instead of a JSON string, so Windows PowerShell's ParameterBinding/Module Logging can no longer capture the plaintext value. Applies module-wide, including `Set-IDUserPassword`, `New-IDUser`, `New-IDSecuredItem`, `Update-IDSecuredItemCredential`, `Set-IDApplicationUserCredential`, `Set-IDUserSecurityQuestion`, `Send-IDUserIdentityVerification`, `Import-IDPersonalApplicationCsv` and the login flow (`New-IDSession`).
- `Get-IDResponse`
  - Now matches any `*json*` content type instead of requiring an exact `application/json` match, fixing responses from SCIM endpoints (`application/scim+json`).
- `Invoke-IDSqlcmd`
  - `-Limit` is now paired with `-PageNumber`/`-PageSize` automatically when only `-Limit` is supplied, matching how the underlying API actually honors it.
- `Get-IDRoleWebApp`
  - No longer sends an unnecessary request body.
- `Set-IDRole`
  - Corrects the request body shape.
- `New-IDTenantSuffix`
  - Corrects the request body shape.
- `Get-IDAuthenticationPolicyBlock`
  - Adds an `-ID` alias to `-Name` for direct pipeline input from `Get-IDAuthenticationPolicyLink`.
- `Hide-SecretValue`
  - Adds `OldPassword` to the list of redacted field names in debug output.

### Fixed

- `Get-IDConnector`
  - Corrects the result property read from the response.
- `Get-IDTenant`
  - Corrects the output property read from the response.
- `Get-IDUserRole`
  - Corrects the return property read from the response.

### Removed

- `Get-IDAnalyticsDataset`, `Get-IDAuthenticationPolicyMetadata`, `Get-IDPagedRoleMember`
  - Little practical benefit for API administration, or found to be dead/unconfirmed endpoints.

## [0.4] - 2026-07-19

### Added

- All credit to [Alexander Sageng](https://github.com/Slasky86) for this hefty contribution!!
  - `Get-IDPermission`
  - `Get-IDRole`
  - `New-IDRole`
  - `Update-IDRole`
  - `Add-IDRoleMember`
  - `Remove-IDRoleMember`
  - `Add-IDRolePermission`
  - `Remove-IDRolePermission`
  - `Remove-IDRole`
  - `Get-IDRolePermission`
  - `Get-IDRoleMember`
  - `Set-IDDynamicRoleScript`
  - `Test-IDDynamicRoleScript`
  - `Get-IDRoleApplication`
  - `Get-IDDynamicRoleMember`
  - `Get-IDPagedRoleMember`
  - `Get-IDRoleWebApp`
  - `Get-IDAuthenticationProfile`
  - `Remove-IDAuthenticationProfile`
  - `Get-IDAuthenticationAssuranceLevel`
  - `New-IDAuthenticationProfile`
  - `Set-IDAuthenticationProfile`
  - `Get-IDAuthenticationPolicyModifier`
  - `Get-IDAuthenticationPolicyLink`
  - `Get-IDAuthenticationPolicyBlock`
  - `Get-IDAuthenticationPolicyMetadata`
  - `Get-IDAuthenticationPolicyCloudMobileGP`
  - `Remove-IDAuthenticationPolicyBlock`
  - `Get-IDUserOathOTPClientName`
  - `Get-IDUserPasswordComplexityRequirement`
  - `New-IDAuthenticationPolicy`
  - `New-IDTenantCname`
  - `Remove-IDTenantCname`
  - `Get-IDTenantURL`
  - `Set-IDTenantPreferredCname`
  - `Get-IDTenantSuffix`
  - `New-IDTenantSuffix`
  - `Remove-IDTenantSuffix`
  - `Get-IDTenantCdsSuffix`
  - `New-IDAuthenticationPolicy`
  - `Set-IDAuthenticationPolicy`

### Changed

- N/A

### Fixed

- `New-IDSession`: Adds support for OOB IdP Authentication flows that require a PIN code.
  - Tenants configured to display a PIN in the browser after external IdP login are now prompted for the PIN and completed via `AdvanceAuthentication`. Previously these tenants would hang in the `OobAuthStatus` polling loop with no way to enter the PIN.
  - Credit to Tim Schindler ([aaearon](https://github.com/aaearon))
- SMS 2FA: Resolve issue where using SMS 2FA resulted in script asking for 2FA code before 2FA code was sent to phone
  - Thanks [SkylerWallace](https://github.com/SkylerWallace)!!

## [0.3] - 2025-03-09

### Added

- `New-IDSession: Adds support for Out-of-band IDP Authentication`
  - Federated identity users from an external IDP can now authenticate.
    - Thanks & Credit to Tim Schindler ([aaearon](https://github.com/aaearon)) for this!

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
  - Updated `GetWebSession` method to utilise `Get-IDSession` in order to return the WebSession object from the module`s script scope.

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

- Replaces `[Environment]::GetEnvironmentVariable(`Temp`)` with `[System.IO.Path]::GetTempPath()` to correctly determine %TEMP% directory location on Windows as well as OSX.

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

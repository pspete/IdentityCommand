---
title: "IdentityCommand Release 0.5"
date: 2026-08-25 00:00:00
version: 0.5.147
tags:
  - Release Notes
  - Get-IDApplication
  - New-IDApplication
  - Set-IDApplication
  - Remove-IDApplication
  - Copy-IDApplication
  - Get-IDApplicationData
  - Get-IDApplicationForUser
  - Get-IDApplicationTemplate
  - Import-IDApplicationTemplate
  - Get-IDApplicationPermission
  - Set-IDApplicationPermission
  - Get-IDApplicationTag
  - New-IDApplicationTag
  - Set-IDApplicationTag
  - Rename-IDApplicationTag
  - Remove-IDApplicationTag
  - Set-IDApplicationIcon
  - Set-IDApplicationUserCredential
  - Get-IDSecuredItem
  - New-IDSecuredItem
  - Set-IDSecuredItemIcon
  - Set-IDSecuredItemTag
  - Update-IDSecuredItemCredential
  - Get-IDPersonalApplicationImportFile
  - Get-IDPersonalApplicationImportLog
  - Import-IDPersonalApplicationCsv
  - Get-IDUserPortalData
  - Get-IDCredentialProvider
  - Move-IDUserOwnership
  - Test-IDApplicationCatalogAvailability
  - Test-IDApplicationUsername
  - Update-IDCapturedUserApplication
  - Update-IDPersonalUserApplication
  - Update-IDUserApplication
  - Get-IDOrganization
  - New-IDOrganization
  - Set-IDOrganization
  - Remove-IDOrganization
  - Get-IDOrganizationAdministrator
  - Set-IDOrganizationAdministrator
  - Get-IDOrganizationMember
  - Get-IDOrganizationPermission
  - Get-IDOrganizationRole
  - Set-IDOrganizationMembership
  - Remove-IDSCIMUser
  - Remove-IDSCIMGroup
  - Remove-IDSCIMContainer
  - Remove-IDSCIMContainerPermission
  - Remove-IDSCIMPrivilegedData
  - Get-IDSCIMResourceType
  - Get-IDSCIMSchema
  - Get-IDSCIMServiceProviderConfig
  - New-IDUser
  - Set-IDUser
  - Remove-IDUser
  - Enable-IDUser
  - Disable-IDUser
  - Import-IDUserCsv
  - Set-IDUserPassword
  - Set-IDUserPhonePin
  - Set-IDUserPicture
  - Get-IDUserAttribute
  - Set-IDUserAttribute
  - Get-IDUserHierarchy
  - Get-IDUserInfo
  - Get-IDUserRiskLevel
  - Get-IDUserSecurityQuestion
  - Set-IDUserSecurityQuestion
  - Reset-IDUserSecurityQuestion
  - Get-IDUserU2FDevice
  - Get-IDUserU2FRegistrationChallenge
  - Complete-IDUserU2FRegistrationChallenge
  - Remove-IDUserU2FDevice
  - Close-IDUserSession
  - Send-IDUserIdentityVerification
  - Send-IDUserInvite
  - Send-IDUserLoginEmail
  - Sync-IDUserOathToken
  - Test-IDUserLockedOutByPolicy
  - Get-IDWorkflowJob
  - Get-IDWorkflowJobReport
  - Start-IDWorkflowJob
  - Remove-IDWorkflowJob
  - Send-IDWorkflowEvent
  - New-IDDevice
  - Remove-IDDevice
  - Unregister-IDDevice
  - Get-IDTenantConfigEntry
  - Set-IDTenantConfigEntry
  - Remove-IDTenantConfigEntry
  - Set-IDTenantConfiguration
  - Get-IDTenantMessageTemplate
  - Get-IDTenantSecurityQuestion
  - Set-IDTenantSecurityQuestion
  - Remove-IDTenantSecurityQuestion
  - New-IDPassword
  - New-IDSession
  - Invoke-IDSqlcmd
  - Get-IDRoleWebApp
  - Set-IDRole
  - New-IDTenantSuffix
  - Get-IDAuthenticationPolicyBlock
  - Get-IDAuthenticationPolicyLink
  - Get-IDConnector
  - Get-IDTenant
  - Get-IDUserRole
---

## [0.5.147]

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

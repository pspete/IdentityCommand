---
title: "IdentityCommand Release 0.4"
date: 2026-07-19 00:00:00
version: 0.4.86
tags:
  - Release Notes
  - Get-IDPermission
  - Get-IDRole
  - New-IDRole
  - Add-IDRoleMember
  - Remove-IDRoleMember
  - Add-IDRolePermission
  - Remove-IDRolePermission
  - Remove-IDRole
  - Get-IDRolePermission
  - Get-IDRoleMember
  - Set-IDDynamicRoleScript
  - Test-IDDynamicRoleScript
  - Get-IDRoleApplication
  - Get-IDDynamicRoleMember
  - Get-IDRoleWebApp
  - Get-IDAuthenticationProfile
  - Remove-IDAuthenticationProfile
  - Get-IDAuthenticationAssuranceLevel
  - New-IDAuthenticationProfile
  - Set-IDAuthenticationProfile
  - Get-IDAuthenticationPolicyModifier
  - Get-IDAuthenticationPolicyLink
  - Get-IDAuthenticationPolicyBlock
  - Get-IDAuthenticationPolicyCloudMobileGP
  - Remove-IDAuthenticationPolicyBlock
  - Get-IDUserOathOTPClientName
  - Get-IDUserPasswordComplexityRequirement
  - New-IDAuthenticationPolicy
  - New-IDTenantCname
  - Remove-IDTenantCname
  - Get-IDTenantURL
  - Set-IDTenantPreferredCname
  - Get-IDTenantSuffix
  - New-IDTenantSuffix
  - Remove-IDTenantSuffix
  - Get-IDTenantCdsSuffix
  - Set-IDAuthenticationPolicy
  - New-IDSession
---

## [0.4.86]

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

### Fixed

- `New-IDSession`: Adds support for OOB IdP Authentication flows that require a PIN code.
  - Tenants configured to display a PIN in the browser after external IdP login are now prompted for the PIN and completed via `AdvanceAuthentication`. Previously these tenants would hang in the `OobAuthStatus` polling loop with no way to enter the PIN.
  - Credit to Tim Schindler ([aaearon](https://github.com/aaearon))
- SMS 2FA: Resolve issue where using SMS 2FA resulted in script asking for 2FA code before 2FA code was sent to phone
  - Thanks [SkylerWallace](https://github.com/SkylerWallace)!!

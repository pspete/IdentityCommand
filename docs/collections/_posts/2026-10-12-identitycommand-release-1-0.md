---
title: "IdentityCommand Release 1.0"
date: 2026-10-12 00:00:00
version: 1.0.0
tags:
  - Release Notes
  - New-IDSession
  - New-IDPlatformToken
  - Get-IDSession
---

## [1.0.0]

1.0.0: from this release, IdentityCommand follows semantic versioning, so breaking changes come only in a major release.

### Added

- Support for companion modules (`IdentityCommand.SCA`, `IdentityCommand.SIA` and the others) to connect on
  first use, finding their service url by platform discovery and using the `IdentityCommand` session, with no
  connection step after `New-IDSession` or `New-IDPlatformToken`.
- `Get-IDSession` reports the tenant's shared services `Subdomain`, read from the sign-in token.
- `New-IDSession` and `New-IDPlatformToken` accept the tenant's shared services subdomain (`-subdomain sometenant`)
  in place of `-tenant_url`, finding the Identity URL by platform discovery.

### Changed

- `New-IDSession` and `New-IDPlatformToken` end any existing session when they start, so a failed sign-in
  leaves no session. Previously, the earlier user and start time were kept, without a usable web session.
- CI caches the PowerShell modules it installs, so dependency installs skip the PowerShell Gallery on a cache hit.

### Fixed

- A failed request now reports its own error. Previously, a failed sign-in (for example, to a mistyped or unreachable tenant URL) first
  reported `Cannot find a variable with the name 'IDSession'`, and an error response with no body reported an empty message.
- Requests sent with an `Accept` header now succeed: Secrets Manager, SecureAI and Secrets Hub commands previously failed with
  `A parameter cannot be found that matches parameter name 'Accept'`. The header applies to that request only, and is not
  left on the shared session.

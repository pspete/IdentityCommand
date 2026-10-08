---
title: "IdentityCommand Release 0.6"
date: 2026-09-07 00:00:00
version: 0.6.158
tags:
  - Release Notes
---

## [0.6.158]

### Added

- Shared private helper functions for IdentityCommand.SCA & IdentityCommand.SIA

### Fixed

- `Invoke-IDRestMethod` no longer downgrades the TLS configuration of the session.
  - On PowerShell Core, `-SslProtocol TLS12` is no longer set. `WebSslProtocol` is a flags enum, so
    it permitted TLS 1.2 and nothing else, excluding TLS 1.3. The connection now negotiates the
    strongest protocol both ends support.
  - On Windows PowerShell, a `SystemDefault` security protocol is left untouched rather than being
    replaced with TLS 1.2 only. The previous guard tested `SystemDefault -match 'Tls12'`, which is
    false, so a process on .NET Framework 4.7 or above - where `SystemDefault` is both the default
    and the correct value - was pinned to TLS 1.2 on its first request, and a process with TLS 1.3
    enabled had it stripped. TLS 1.2 is now added only where an explicit legacy protocol is set, and
    is combined with the protocols already permitted.
  - Applies equally to IdentityCommand.SIA, IdentityCommand.SCA and IdentityCommand.DiscoveryMgmt,
    which dot-source this module's private functions.

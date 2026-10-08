---
title: "IdentityCommand Release 0.8"
date: 2026-10-08 00:00:00
version: 0.8.0
tags:
  - Release Notes
---

## [0.8.0]

### Added

- Faster module load, in roughly a quarter of the previous time: the published module is now a single
  combined `IdentityCommand.psm1`, instead of over 200 function files loaded one by one at import.
- Documentation site launched at [www.pspete.dev/IdentityCommand](https://www.pspete.dev/IdentityCommand/):
  getting started and authentication guides, release notes, and command reference for IdentityCommand
  and its companion modules. The module manifest `ProjectUri` now points to it.

### Changed

- Build, test and release move from AppVeyor to GitHub Actions, using the shared
  [pspete.Build](https://github.com/pspete/pspete.Build) scripts. The built module is tested on
  Windows PowerShell 5.1, and on PowerShell 7 on Windows and Linux.

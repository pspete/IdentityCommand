---
title: "IdentityCommand Release 0.7"
date: 2026-10-07 00:00:00
version: 0.7.159
tags:
  - Release Notes
---

## [0.7.159]

### Added

- `Find-SharedServicesURL` recognises the platform discovery keys for further shared services:
  `aigw`, `alerong`, `ars`, `cds`, `compass`, `dms`, `uap` and `userportal`.
- `ConvertTo-FilterClause`: formats a single `field operator value` filter clause, quoting and
  escaping the value as the ISPSS filter dialects require. Services differ in operator vocabulary,
  clause joining and parenthesisation, so companion modules assemble their own expressions from
  these clauses. The clause is not url encoded - `Add-QueryString` encodes the query string as a
  whole.

### Changed

- `Resolve-ServiceUrl` now throws when the requested service is absent from the platform discovery
  response, instead of returning a null `ServiceUrl`. A service which is not enabled on the tenant,
  or a mistyped service key, previously left the calling `Connect-` command holding a session bound
  to no URL at all.
- `Resolve-ServiceUrl` also strips a trailing slash from the resolved `ServiceUrl`. Services vary in
  whether they publish a `/api` suffix, a trailing slash, both or neither, so callers can now append
  their own `/<path>` unconditionally.
- `Resolve-ServiceUrl` accepts `-BaseUrlOnly`, returning only the scheme and host of the service URL
  and reporting any path separately as `ServicePath`. Needed by services which publish a path along
  with the host, such as `alerong` (Remote Access). Includes a recovery for discovery responses which
  omit the slash between host and path.
- `Resolve-ServiceUrl` output carries a `ServicePath` property, empty unless `-BaseUrlOnly` was used.
- `Get-PagedResult` Offset style recognises two further ways an endpoint reports the end of a set:
  `-LastPageKey` for a boolean last page flag such as `isLastPage`, and `-OffsetResponseKey` for a
  next offset echoed back on the response and omitted on the final page. `-OffsetResponseKey` accepts
  a dotted path for a nested value, for example `paging.offset`.
- `Get-PagedResult` Offset style can page a `POST` endpoint, for those which take their paging values
  in the request body: `-Method POST` with `-BodyTemplate`, and `-BodyPagingProperty` when the paging
  values sit in a nested object. The body is cloned per page with only the offset replaced, so
  filters and search terms carry across pages.

### Fixed

- `Get-PagedResult` Cursor style stops when the server returns the same continuation token it was
  sent, instead of requesting that page indefinitely. Reachable against an endpoint which reports a
  token unconditionally, or one which ignores the token parameter altogether.
- `Select-ChallengeMechanism` uses the full `System.Management.Automation.Host.ChoiceDescription`
  type name instead of a `using namespace` statement, so it works when the module is combined into
  a single file and when companion modules copy the private helpers.

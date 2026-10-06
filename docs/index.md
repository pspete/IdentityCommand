---
title: IdentityCommand
subtitle: PowerShell modules for the Palo Alto Idira (formerly CyberArk) Identity platform
hide_hero: true
---

<div class="has-text-centered mb-6">
  <img src="{{ '/media/images/IdentityCommand.png' | relative_url }}" alt="IdentityCommand" width="471">
</div>

**IdentityCommand** is a PowerShell module that wraps the REST API for a Palo Alto Idira (formerly CyberArk) Identity tenant, giving you easy-to-use commands for authentication (including MFA/SAML/OIDC flows) and administration - users, roles, applications, organizations, authentication policies, SCIM provisioning, and more - all from within PowerShell.

IdentityCommand is also the foundation for a growing family of `IdentityCommand.*` modules that administer the wider Idira SaaS platform. Each builds on IdentityCommand's authentication, so one sign-in works across all of them.

```powershell
Install-Module -Name IdentityCommand -Scope CurrentUser
New-IDSession -tenant_url https://sometenant.id.cyberark.cloud -Credential (Get-Credential)
```

## Modules

<div class="columns is-multiline module-cards">
{% for item in site.data.navigation %}
  {% assign module = site.data.menus[item.module] %}
  <div class="column is-one-third-desktop is-half-tablet">
    <a class="card is-block" href="{{ item.link | relative_url }}">
      {% if module.image %}<div class="card-image"><img src="{{ module.image | relative_url }}" alt=""></div>{% endif %}
      <div class="card-content">
        <p class="title is-5">{{ module.label | replace: ".", ".<wbr>" }}</p>
        <p class="module-description">{{ module.description }}</p>
      </div>
    </a>
  </div>
{% endfor %}
</div>

## Pre-1.0.0

- Expect changes, although we will do our best to keep these to a minimum.
- Issues / PRs are encouraged & appreciated.
- Many commands are built from documented API shapes but not yet exercised against a live tenant - your feedback genuinely shapes what ships next. If you can try one against your own tenant, [open an issue](https://github.com/pspete/IdentityCommand/issues/new) with what you found.
- Real-world usage is still expected to shape command names, parameters, and how commands are grouped, so don't consider anything final yet.

## Coverage

IdentityCommand ships 170+ commands - see the [command reference]({{ '/commands/' | relative_url }}).

| Area                         | Covers                                                                                                                            |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| **Session / Authentication** | Interactive & service-account sign-in (credential, SAML, MFA challenges), session lifecycle, platform tokens                      |
| **Users**                    | User CRUD, roles, attributes, security questions, U2F devices, sessions, invites, identity verification, password/lock management |
| **Roles**                    | Roles, membership (users/roles/groups), administrative permissions, dynamic role scripts                                          |
| **Applications**             | Application catalog CRUD, permissions, tags, icons, personal apps & secured items, CSV import                                     |
| **Organizations**            | Organization/tenant-partition administration, membership, administrators, permissions                                             |
| **Policies**                 | Authentication profiles & policies, MFA assurance levels, OTP/password complexity settings                                        |
| **SCIM**                     | SCIM-based provisioning for users, groups, containers, container permissions & privileged data                                    |
| **Tenant**                   | Tenant configuration, cnames, suffixes, security questions, message templates                                                     |
| **Workflow**                 | Access-request workflow jobs and approval/denial events                                                                           |
| **Devices**                  | Device registration & management                                                                                                  |
| **Core**                     | Lower-level helpers - ad-hoc SQL queries, permission lookups, download URLs, password generation                                  |

## Support

The IdentityCommand modules are neither developed nor supported by Palo Alto Networks / CyberArk; vendor support channels are not appropriate for help with these modules.
Seek help by [opening an issue](https://github.com/pspete/IdentityCommand/issues/new) on the relevant module's repository.

Please support continued development; consider [sponsoring @pspete on GitHub Sponsors](https://github.com/sponsors/pspete).

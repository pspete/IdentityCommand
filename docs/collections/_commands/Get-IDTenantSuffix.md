---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDTenantSuffix

## SYNOPSIS
Get tenant suffixes

## SYNTAX

```
Get-IDTenantSuffix [<CommonParameters>]
```

## DESCRIPTION
Returns all directory suffixes (aliases) configured for the tenant, covering both Cloud Directory (CDS) and AD/Federated Directory Services (AD&FDS) users. A suffix is the domain portion of a username used to identify which tenant a user belongs to.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDTenantSuffix
```

Return all suffixes configured for the tenant

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

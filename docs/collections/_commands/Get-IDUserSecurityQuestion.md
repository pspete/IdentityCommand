---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserSecurityQuestion

## SYNOPSIS
Get the tenant's security question policy

## SYNTAX

```
Get-IDUserSecurityQuestion [<CommonParameters>]
```

## DESCRIPTION
Despite its "User" naming, this returns the tenant-wide security question **policy** (`AnswerMinLength`/`MaxQuestions`/`MinAdminQuestions`/`MinUserQuestions`/`Questions`) applied to the current session's tenant - not a specific user's answered questions. The underlying `UserMgmt/GetSecurityQuestions` endpoint takes no per-user scoping. This is distinct from `Get-IDTenantSecurityQuestion`, which returns the tenant's admin security questions.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserSecurityQuestion
```

Returns the tenant's security question policy.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

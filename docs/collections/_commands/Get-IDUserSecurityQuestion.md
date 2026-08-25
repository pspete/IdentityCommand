---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserSecurityQuestion

## SYNOPSIS
Get the current user's security questions

## SYNTAX

```
Get-IDUserSecurityQuestion [<CommonParameters>]
```

## DESCRIPTION
Returns the security question policy (`AnswerMinLength`/`MaxQuestions`/`MinAdminQuestions`/`MinUserQuestions`) together with the current session user's own configured security questions (`Questions`). There's no `-ID`/`-Username` parameter - scoping to "the current user" comes from the authenticated session itself, confirmed live: a question added to one account via `Set-IDUserSecurityQuestion` shows up in that same account's `Questions` when this is run. This is distinct from `Get-IDTenantSecurityQuestion`, which returns the tenant's admin security questions.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserSecurityQuestion
```

Returns the current user's security question policy and configured questions.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

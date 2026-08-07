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
Returns the security questions configured for the current user. This is distinct from Get-IDTenantSecurityQuestion, which returns tenant-wide admin security questions.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDUserSecurityQuestion
```

Returns the current user's security questions.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDPermission

## SYNOPSIS
Get all available permissions

## SYNTAX

```
Get-IDPermission [<CommonParameters>]
```

## DESCRIPTION
Returns the full list of permissions (rights) available in the tenant, such as those assignable to a role with Add-IDRolePermission. Internally this runs a Redrock query against the platform's get_superrights script and returns every row.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDPermission
```

Return all available permissions defined in the tenant

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

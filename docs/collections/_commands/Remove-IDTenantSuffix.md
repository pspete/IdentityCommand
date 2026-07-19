---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDTenantSuffix

## SYNOPSIS
Remove tenant suffixes

## SYNTAX

```
Remove-IDTenantSuffix [-Suffixes] <Array> [<CommonParameters>]
```

## DESCRIPTION
Deletes one or more directory suffixes (aliases) from the tenant.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-IDTenantSuffix -Suffixes "corp.example.com","corp2.example.com"
```

Remove the specified suffixes from the tenant

## PARAMETERS

### -Suffixes
The new tenant Suffix

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

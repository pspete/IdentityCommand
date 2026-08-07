---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDTenantSecurityQuestion

## SYNOPSIS
Get tenant admin security questions

## SYNTAX

### All (Default)
```
Get-IDTenantSecurityQuestion [<CommonParameters>]
```

### ID
```
Get-IDTenantSecurityQuestion -ID <String> [<CommonParameters>]
```

## DESCRIPTION
Returns the security questions configured for tenant administrators, either all of them or a single question by ID.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDTenantSecurityQuestion
```

Returns all tenant admin security questions.

### Example 2
```powershell
PS C:\> Get-IDTenantSecurityQuestion -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the specified security question.

## PARAMETERS

### -ID
The ID of the security question to retrieve.

```yaml
Type: String
Parameter Sets: ID
Aliases: Uuid

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

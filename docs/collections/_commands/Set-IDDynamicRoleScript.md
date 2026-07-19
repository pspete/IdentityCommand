---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDDynamicRoleScript

## SYNOPSIS
Set the membership script for a dynamic role

## SYNTAX

```
Set-IDDynamicRoleScript [-Name] <Object> [-Script] <String> [<CommonParameters>]
```

## DESCRIPTION
Sets (or replaces) the script used to compute membership for a script-based (dynamic) role. Use `Test-IDDynamicRoleScript` to validate a script against a user before applying it here.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDDynamicRoleScript -Name 'Dynamic Role' -Script 'function isRoleMember(user) { return user.Email.endsWith("@somedomain.com"); }'
```

Set the membership script for the dynamic role

## PARAMETERS

### -Name
The name (or ID) of the dynamic role to set the membership script for.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Script
The script text that defines the role's membership logic.

```yaml
Type: String
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

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

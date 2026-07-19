---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Test-IDDynamicRoleScript

## SYNOPSIS
Test a dynamic role membership script

## SYNTAX

```
Test-IDDynamicRoleScript [-User] <Object> [-Script] <String> [<CommonParameters>]
```

## DESCRIPTION
Evaluates a dynamic role membership script against a specified user without saving it, so the script's logic can be validated before it's applied with `Set-IDDynamicRoleScript`.

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-IDDynamicRoleScript -User someuser@somedomain.com -Script 'function isRoleMember(user) { return user.Email.endsWith("@somedomain.com"); }'
```

Test whether the script would consider the specified user a member

## PARAMETERS

### -Script
The script text to test.

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

### -User
The username (or ID) of the user to evaluate the script against.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

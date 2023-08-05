---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Clear-IDUserSession

## SYNOPSIS
Sign Out a user from all CyberArk Identity sessions everywhere.

## SYNTAX

```
Clear-IDUserSession [-id] <String> [<CommonParameters>]
```

## DESCRIPTION
Invalidates all sessions for a user.
All the sessions and cookies present for that user will be deleted and user needs to be login again.
Only system administrator, users with user management rights, or the user itself can invoke this API.

## EXAMPLES

### Example 1
```
PS C:\> Clear-IDUserSession -id "abc-1234-def-5678-ghi-90-jkl"
```

Signs out user with Uuid of "abc-1234-def-5678-ghi-90-jkl"

## PARAMETERS

### -id
The unique ID (Uuid) of the user to sign out.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

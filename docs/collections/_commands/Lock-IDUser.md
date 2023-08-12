---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Lock-IDUser

## SYNOPSIS
Cloud lock a user

## SYNTAX

```
Lock-IDUser [-user] <String> [<CommonParameters>]
```

## DESCRIPTION
Enable cloud lock for a specified user

## EXAMPLES

### Example 1
```
PS C:\> Lock-IDUser -user 1234
```

Set cloud lock status to true for user with matching id

## PARAMETERS

### -user
The unique ID (Uuid) of the user to cloud lock.

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

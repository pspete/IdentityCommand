---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Unlock-IDUserCloudLock

## SYNOPSIS
Cloud unlock a user

## SYNTAX

```
Unlock-IDUserCloudLock [-user] <String> [<CommonParameters>]
```

## DESCRIPTION
Disable cloud lock for a specified user

## EXAMPLES

### Example 1
```
PS C:\> Unlock-IDUserCloudLock -user 1234
```

Set cloud lock status to false for user with matching id

## PARAMETERS

### -user
The unique ID (Uuid) of the user to cloud unlock

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

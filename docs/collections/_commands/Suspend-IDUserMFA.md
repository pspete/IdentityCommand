---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Suspend-IDUserMFA

## SYNOPSIS
Suspend MFA for a User

## SYNTAX

```
Suspend-IDUserMFA [-ID] <String> [[-timespan] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Suspend MFA to exempt a user from MFA login for a specified amount of time.

## EXAMPLES

### Example 1
```
PS C:\> Suspend-IDUserMFA -ID 1234
```

Exempts user with id 2134 from MFA for 10 minutes (default timespan)

### Example 1
```
PS C:\> Suspend-IDUserMFA -ID 1234 -timespan 2
```

Exempts user with id 2134 from MFA for 2 minutes

## PARAMETERS

### -ID
The unique ID (Uuid) of the user to exempt from MFA

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

### -timespan
Amount of time to exempt the user from MFA (default=10 minutes)

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

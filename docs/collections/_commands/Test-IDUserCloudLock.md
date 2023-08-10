---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Test-IDUserCloudLock

## SYNOPSIS
Check if a user is cloud locked

## SYNTAX

```
Test-IDUserCloudLock [-ID] <String> [<CommonParameters>]
```

## DESCRIPTION
Check if a user is cloud locked

## EXAMPLES

### Example 1
```powershell
PS C:\> Test-IDUserCloudLock-id 1234
```

Checks if user with ID 1234 is cloud locked

## PARAMETERS

### -ID
The unique ID (Uuid) of the user to check cloud lock status

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

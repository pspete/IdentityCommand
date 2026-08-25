---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDPassword

## SYNOPSIS
Generate a random password

## SYNTAX

```
New-IDPassword [-ID] <String> [[-Length] <Int32>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generates a random password value for the specified user, using the tenant's configured password
complexity rules.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDPassword -ID '881512ca-d441-4997-a55e-19ec5374f3b3'
```

Generates a random password for the specified user, using the tenant's default length.

### Example 2
```powershell
PS C:\> New-IDPassword -ID '881512ca-d441-4997-a55e-19ec5374f3b3' -Length 16
```

Generates a random 16-character password for the specified user.

## PARAMETERS

### -ID
The UUID of the user to generate a password for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid, UserUuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Length
The length of the password to generate.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
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

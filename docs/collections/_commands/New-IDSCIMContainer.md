---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDSCIMContainer

## SYNOPSIS
Create a SCIM Container

## SYNTAX

```
New-IDSCIMContainer [-Attributes] <Hashtable> [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Creates a new SCIM Container (Safe) resource.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDSCIMContainer -Attributes @{ name = 'SomeSafe'; schemas = @('urn:ietf:params:scim:schemas:cyberark:1.0:Safe') }
```

Creates a new SCIM Container (Safe).

## PARAMETERS

### -Attributes
A hashtable representing the SCIM resource document. See the command examples for the recorded field shape.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
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

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

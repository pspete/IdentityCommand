---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDSCIMPrivilegedData

## SYNOPSIS
Replace SCIM Privileged Data

## SYNTAX

```
Set-IDSCIMPrivilegedData [-ID] <String> [-Attributes] <Hashtable>
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Replaces (PUT) an existing SCIM Privileged Data resource in full.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDSCIMPrivilegedData -ID 'somedataid' -Attributes @{ name = 'SomeAccount'; schemas = @('urn:ietf:params:scim:schemas:cyberark:1.0:PrivilegedData') }
```

Replaces the specified SCIM Privileged Data item.

## PARAMETERS

### -Attributes
A hashtable representing the SCIM resource document. See `New-IDSCIMPrivilegedData` for the recorded field shape.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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

### -ID
The unique ID of the resource.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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

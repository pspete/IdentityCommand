---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Update-IDSCIMUser

## SYNOPSIS
Patch a SCIM User

## SYNTAX

```
Update-IDSCIMUser [-ID] <String> [-Operations] <Array> [[-Schemas] <Array>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Partially updates (PATCH) an existing SCIM User resource using SCIM PATCH operations.

## EXAMPLES

### Example 1
```powershell
PS C:\> Update-IDSCIMUser -ID 'someuserid' -Operations @(@{ op = 'replace'; path = 'active'; value = $false })
```

Deactivates the specified SCIM User.

## PARAMETERS

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

### -Operations
An array of SCIM PATCH operation hashtables, e.g. @{op='replace'; path='active'; value=$false}.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Schemas
The SCIM schema URN(s) for the request. Defaults to the standard SCIM PATCH schema URN if not supplied.

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

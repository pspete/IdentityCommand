---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDTenantPreferredCname

## SYNOPSIS
Set the preferred tenant cname

## SYNTAX

```
Set-IDTenantPreferredCname [-customCname] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets a previously registered custom cname as the tenant's preferred cname, the primary URL presented to users when they sign in.

## EXAMPLES

### Example 1
```
PS C:\> Set-IDTenantPreferredCname -customCname login.example.com
```

Set login.example.com as the tenant's preferred cname

## PARAMETERS

### -customCname
The custom cname to set as preferred, for example login.example.com.
The tenant's id.cyberark.cloud domain suffix is appended automatically if not already present.

```yaml
Type: Object
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

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

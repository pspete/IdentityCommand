---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDTenantCname

## SYNOPSIS
Register a new tenant cname

## SYNTAX

```
New-IDTenantCname [-cnamePrefix] <Object> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Registers a new custom cname (vanity DNS hostname) for the tenant, allowing users to sign in via a custom URL instead of the tenant's default id.cyberark.cloud subdomain.
DNS still needs to be configured separately to point the custom hostname at the tenant.

## EXAMPLES

### Example 1
```
PS C:\> New-IDTenantCname -cnamePrefix login.example.com
```

Register login.example.com as a cname for the tenant

## PARAMETERS

### -cnamePrefix
The custom cname to register for the tenant, for example login.example.com.

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
Default value: False
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
Default value: False
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

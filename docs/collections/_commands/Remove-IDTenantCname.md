---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Remove-IDTenantCname

## SYNOPSIS
Remove a tenant cname

## SYNTAX

```
Remove-IDTenantCname [-customCname] <Object> [<CommonParameters>]
```

## DESCRIPTION
Unregisters a previously registered custom cname (vanity DNS hostname) from the tenant.

## EXAMPLES

### Example 1
```powershell
PS C:\> Remove-IDTenantCname -customCname login.example.com
```

Remove the login.example.com cname from the tenant

## PARAMETERS

### -customCname
The custom cname to remove from the tenant, for example login.example.com. The tenant's id.cyberark.cloud domain suffix is appended automatically if not already present.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### System.Object

## NOTES

## RELATED LINKS

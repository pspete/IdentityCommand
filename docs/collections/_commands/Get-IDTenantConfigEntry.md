---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDTenantConfigEntry

## SYNOPSIS
Get a tenant configuration entry

## SYNTAX

```
Get-IDTenantConfigEntry [-Key] <String> [[-Default] <String>] [<CommonParameters>]
```

## DESCRIPTION
Returns the value of a single tenant configuration entry by key. This wraps a different underlying config store to Get-IDTenantConfiguration (which wraps the tenant's custom configuration) - the exact set of recognised keys for this store is undocumented.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDTenantConfigEntry -Key 'SomeKey'
```

Returns the value of the specified configuration entry.

### Example 2
```powershell
PS C:\> Get-IDTenantConfigEntry -Key 'SomeKey' -Default 'SomeDefault'
```

Returns the value of the specified configuration entry, or the specified default if it is not set.

## PARAMETERS

### -Default
A default value to return if the entry is not set.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Key
The key of the configuration entry to retrieve.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
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

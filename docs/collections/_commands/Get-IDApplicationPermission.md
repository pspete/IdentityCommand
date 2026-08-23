---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDApplicationPermission

## SYNOPSIS
Get the permission grants on an application

## SYNTAX

```
Get-IDApplicationPermission [-ID] <String> [-IncludeInherited] [<CommonParameters>]
```

## DESCRIPTION
Returns the access control entries (ACEs) for an application - each principal's direct permission grant, as set by `Set-IDApplicationPermission`.

By default only direct, non-inherited entries are returned. `-IncludeInherited` also returns role-based/system administration grants inherited from elsewhere in the tenant, which aren't scoped to this application and can't be changed via `Set-IDApplicationPermission`.

Each entry's `Grant`/`GrantStr` properties are the raw permission bitmask as returned by the API - they haven't yet been decoded to the named rights `Set-IDApplicationPermission` uses.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDApplicationPermission -ID 'a1b2c3d4-0000-0000-0000-000000000000'
```

Returns the application's direct permission grants.

## PARAMETERS

### -ID
The unique ID of the application to get permissions for.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid, AppKey

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -IncludeInherited
Also return inherited (role-based/system administration) grants not scoped to this application.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

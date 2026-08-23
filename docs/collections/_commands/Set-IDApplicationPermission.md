---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDApplicationPermission

## SYNOPSIS
Set a principal's permission on an application

## SYNTAX

```
Set-IDApplicationPermission [-ID] <String> [-Principal] <String> [-PType] <String> [-PrincipalId] <String> [-Grant <Boolean>] [-View <Boolean>] [-Admin <Boolean>] [-ViewDetail <Boolean>] [-Delete <Boolean>] [-Execute <Boolean>] [-Automatic <Boolean>] [-DirectoryServiceUuid <String>] [-ExternalUuid <String>] [-SystemName <String>] [-Type <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets a user or role's rights on an application to exactly the rights set to `$true`. This replaces the existing permission grant for that principal on the application - it isn't incremental.

Every right defaults to `$false` if not specified, so passing none of them revokes the principal's access entirely (sends `Rights` of `None`). Since each right is a named boolean property rather than a switch, a whole permission set can be piped in from an object with matching property names - e.g. an imported CSV row.

`-SystemName`/`-ExternalUuid` are only sent for a `User` `-PType`, defaulting to `-Principal`/`-PrincipalId` respectively when not explicitly supplied - a `Role` grant doesn't carry these fields at all. `-Type` defaults to `-PType` when not explicitly supplied.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDApplicationPermission -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Principal 'someuser@somedomain.com' -PType 'User' -View $true -Execute $true -PrincipalId '<user-uuid>' -DirectoryServiceUuid '<from Get-IDUserAttribute>'
```

Sets the specified user's rights on the application to View and Execute only.

### Example 2
```powershell
PS C:\> Set-IDApplicationPermission -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Principal 'someuser@somedomain.com' -PType 'User' -PrincipalId '<user-uuid>'
```

Revokes the specified user's rights on the application (no rights set to `$true`).

### Example 3
```powershell
PS C:\> Import-Csv .\permissions.csv | Set-IDApplicationPermission
```

Applies a permission set per row of a CSV with columns matching this command's parameter names (`ID`, `Principal`, `PType`, `PrincipalId`, and any of the right columns).

## PARAMETERS

### -ID
The unique ID of the application on which to set permissions.

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

### -Principal
The username of the user or role to set permission for.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PType
The type of principal being granted permission.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PrincipalId
The UUID of the user or role being granted permission.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Grant
Whether to include the "grant" right - lets the principal grant this application's permissions to others.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -View
Whether to include the "view" right.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Admin
Whether to include the "admin" right.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -ViewDetail
Whether to include the "view detail" right.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Delete
Whether to include the "delete" right.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Execute
Whether to include the "execute" right - lets the principal run the application.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Automatic
Whether to include the "automatic" right.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -DirectoryServiceUuid
The directory service UUID the principal belongs to (see `Get-IDUserAttribute`).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (empty string)
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExternalUuid
The principal's external UUID. Only sent for a `User` `-PType`. Defaults to `-PrincipalId` if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Value of -PrincipalId
Accept pipeline input: False
Accept wildcard characters: False
```

### -SystemName
The principal's system name. Only sent for a `User` `-PType`. Defaults to `-Principal` if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Value of -Principal
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
The principal's type, as recorded on the grant entry itself. Defaults to `-PType` if not specified.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Value of -PType
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

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

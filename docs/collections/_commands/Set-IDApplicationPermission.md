---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Set-IDApplicationPermission

## SYNOPSIS
Grant a principal permission on an application

## SYNTAX

```
Set-IDApplicationPermission [-ID] <String> [-Principal] <String> [-PType] <String> [-Rights] <String[]> [-PrincipalId] <String> [-DirectoryServiceUuid <String>] [-ExternalUuid <String>] [-SystemName <String>] [-Type <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Grants a user or role one or more rights on an application. This replaces the existing permission grant for that principal on the application with the one supplied.

`-Rights` accepts one or more of the valid flag names (`Grant`, `View`, `Admin`, `ViewDetail`, `Delete`, `Execute`, `Automatic`) and are joined into the comma-separated string the API expects - `Execute` is the "run this app" right, not `Run`.

`-SystemName`/`-ExternalUuid`/`-Type` default to `-Principal`/`-PrincipalId`/`-PType` respectively when not explicitly supplied - override them if a real case ever needs them to diverge.

## EXAMPLES

### Example 1
```powershell
PS C:\> Set-IDApplicationPermission -ID 'a1b2c3d4-0000-0000-0000-000000000000' -Principal 'someuser@somedomain.com' -PType 'User' -Rights 'View','Execute' -PrincipalId '<user-uuid>' -DirectoryServiceUuid '<from Get-IDUserAttribute>'
```

Grants the specified user View and Execute rights on the application.

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
The username of the user or role to grant permission to.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
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
Accept pipeline input: False
Accept wildcard characters: False
```

### -Rights
One or more rights to grant. Confirmed valid values: `Grant`, `View`, `Admin`, `ViewDetail`, `Delete`, `Execute`, `Automatic`. Joined into the comma-separated string the API expects.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrincipalId
The UUID of the user or role being granted permission.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
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
The principal's external UUID. Defaults to `-PrincipalId` if not specified.

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
The principal's system name. Defaults to `-Principal` if not specified.

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

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

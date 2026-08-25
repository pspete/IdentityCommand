---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDRole

## SYNOPSIS
Get details of one or more roles

## SYNTAX

### Redrock (Default)
```
Get-IDRole [-Query <Object>] [<CommonParameters>]
```

### API
```
Get-IDRole -ID <Object> [<CommonParameters>]
```

## DESCRIPTION
By default, returns all roles in the tenant by running a Redrock query against the Role table.
Specify -Query to run a custom Redrock query instead.
Specify -ID to fetch a single role by its ID/UUID/`_RowKey` (not its display name) via the role management API instead of Redrock.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDRole
```

Return all roles, ordered by name

### Example 2
```
PS C:\> Get-IDRole -ID '881512ca-d441-4997-a55e-19ec5374f3b3'
```

Return the role with the matching ID

### Example 3
```
PS C:\> Get-IDRole -Query @{"Script" = "Select * from Role WHERE Name='Role Admins'"}
```

Return roles matching a custom Redrock query

## PARAMETERS

### -ID
The ID/UUID/`_RowKey` of a specific role to fetch - not its display name (a display name only works by coincidence for well-known roles whose RowKey happens to equal their name).
When specified, the role is fetched via the role management API instead of the default Redrock query.

```yaml
Type: Object
Parameter Sets: API
Aliases: Uuid

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Query
A Redrock query hashtable (with a \`Script\` key containing the SQL-like query text) to execute against the \`/redrock/query/\` endpoint.
Defaults to a query that selects all roles ordered by name.

```yaml
Type: Object
Parameter Sets: Redrock
Aliases:

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

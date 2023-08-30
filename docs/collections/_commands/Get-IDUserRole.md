---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserRole

## SYNOPSIS
List roles user is a member of.

## SYNTAX

```
Get-IDUserRole [-ID] <String> [[-Limit] <Int32>] [[-PageNumber] <Int32>] [[-PageSize] <Int32>]
 [[-Caching] <Int32>] [[-SortBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get a list of roles for a user.
Returns user roles and administrative rights associated with the roles.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDUserRole -ID SomeID
```

Return a list of roles for a matching user.

## PARAMETERS

### -ID
The ID of the user

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Limit
The maximum number of results to return for the specified page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PageNumber
The number of pages of results to return.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PageSize
The number of entities to return per page.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Caching
Can be set to the following values: -1: returns live data but writes to the cache for query results.
\<-1: don't read from or write to the cache for query results.
0: use the cache for both read/write with 'caching in minutes' as TTL of the results.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -SortBy
Comma-separated list of column names to sort by.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

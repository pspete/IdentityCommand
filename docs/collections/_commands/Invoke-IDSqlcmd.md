---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Invoke-IDSqlcmd

## SYNOPSIS
Query the database tables

## SYNTAX

```
Invoke-IDSqlcmd [-Script] <String> [[-Limit] <Int32>] [[-PageNumber] <Int32>] [[-PageSize] <Int32>]
 [[-Caching] <Int32>] [[-Direction] <Boolean>] [[-SortBy] <String>] [<CommonParameters>]
```

## DESCRIPTION
The SQL query interface allows you to read database tables for the Identity Solution.
It does not allow you to modify or create data in these tables.

This function requires a script with the SQL code to execute as a query and optional parameters to control the output.

## EXAMPLES

### Example 1
```
PS C:\> Invoke-IDSqlcmd -Script 'Select ID, Username from User ORDER BY Username COLLATE NOCASE'
```

Invoke query on the User table, returning the ID and name for each user who has accessed the cloud service

## PARAMETERS

### -Caching
How the results should be cached.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Direction
Whether the results are sorted in ascending or descending order.

- True: The results are sorted in ascending order.
- False: The results are sorted in descending order.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -PageNumber
The specific page number of results to be returned.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
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
Position: 3
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Script
The SQL code to execute

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

### -SortBy
An optional, comma-separated list of column names to sort by.

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

### System.String
### System.Int32
### System.Boolean
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

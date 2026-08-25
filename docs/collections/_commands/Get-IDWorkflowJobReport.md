---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDWorkflowJobReport

## SYNOPSIS
Get a workflow job report

## SYNTAX

```
Get-IDWorkflowJobReport [-HoursBack] <String> [<CommonParameters>]
```

## DESCRIPTION
Returns a report of workflow jobs, limited to the lookback window specified by `-HoursBack` (required per the vendor's Task Management OpenAPI spec).

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDWorkflowJobReport -HoursBack '24'
```

Returns the job report for the last 24 hours.

## PARAMETERS

### -HoursBack
How many hours before now to start the report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

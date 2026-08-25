---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Stop-IDWorkflowJob

## SYNOPSIS
Cancel a workflow job

## SYNTAX

```
Stop-IDWorkflowJob [-JobId] <String> [-Reason] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Cancels a running job via the Task Management API's `/Task/CancelJob`. `-JobId`/`-Reason` match the vendor's OpenAPI spec exactly (both required), but this operates on a distinct "Task" ID space from `WorkFlowJob` (`JobFlow`) IDs - a `WorkFlowJob` ID from `Get-IDWorkflowJob`/`Start-IDWorkflowJob` is not confirmed to work here.

## EXAMPLES

### Example 1
```powershell
PS C:\> Stop-IDWorkflowJob -JobId 'a1b2c3d4-0000-0000-0000-000000000000' -Reason 'No longer needed'
```

Cancels the specified workflow job.

## PARAMETERS

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

### -JobId
The unique ID of the job to cancel.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Uuid

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Reason
The reason for cancelling the job.

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

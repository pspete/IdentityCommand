---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Send-IDWorkflowEvent

## SYNOPSIS
Send an event to a workflow job

## SYNTAX

```
Send-IDWorkflowEvent [-JobId] <String> [-Event] <String> [[-Sync] <Boolean>] [[-Args] <Hashtable>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sends a named event to a running workflow job, optionally synchronously and with event arguments. For an access-request approval, `-Event 'approve'`/`'reject'` with `-Args` matching the request's own `RequestedOptions` (e.g. `AccessType`/`AssignmentType`/`StartTime`/`EndTime`) is confirmed against a real pending job.

## EXAMPLES

### Example 1
```powershell
PS C:\> Send-IDWorkflowEvent -JobId 'a1b2c3d4-0000-0000-0000-000000000000' -Event 'approve' -Args @{ AccessType = 'App'; AssignmentType = 'window'; StartTime = '2026-08-25T18:33:00.000Z'; EndTime = '2026-08-26T18:33:00.000Z' }
```

Approves the specified access-request job, matching the request's own `RequestedOptions`.

## PARAMETERS

### -Args
A hashtable of arguments to pass with the event. The exact shape expected is job/event-specific.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
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

### -Event
The name of the event to send.

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

### -JobId
The unique ID of the job to send the event to.

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

### -Sync
Whether to send the event synchronously. Defaults to $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: True
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

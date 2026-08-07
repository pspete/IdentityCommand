---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# New-IDQRCodeSession

## SYNOPSIS
Start a QR code authentication session

## SYNTAX

```
New-IDQRCodeSession [[-PollIntervalSeconds] <Int32>] [[-TimeoutSeconds] <Int32>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Starts a QR code authentication session and polls for its status until it completes or the specified timeout elapses.

## EXAMPLES

### Example 1
```powershell
PS C:\> New-IDQRCodeSession
```

Starts a QR code authentication session, polling every 2 seconds for up to 120 seconds.

### Example 2
```powershell
PS C:\> New-IDQRCodeSession -PollIntervalSeconds 5 -TimeoutSeconds 300
```

Starts a QR code authentication session, polling every 5 seconds for up to 5 minutes.

## PARAMETERS

### -PollIntervalSeconds
How often, in seconds, to poll for the session's status. Defaults to 2.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: 2
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutSeconds
The maximum time, in seconds, to poll for before giving up. Defaults to 120.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 120
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

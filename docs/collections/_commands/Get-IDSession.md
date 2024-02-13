---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDSession

## SYNOPSIS
Get the IdentityCommand WebSession

## SYNTAX

```
Get-IDSession [<CommonParameters>]
```

## DESCRIPTION
Exports variables like the URL, Username & WebSession object from the IdentityCommand module scope, either for use in other requests outside of the module scope, or for informational purposes.

Return data also includes details such as session start time, elapsed time, last command time, as well as data for the last invoked command and the results of the previous command.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDSession

Name                           Value
----                           -----
tenant_url                     https://abc1234.id.cyberark.cloud
User                           some.user@somedomain.com
TenantId                       ABC1234
SessionId                      1337CbGbPunk3Sm1ff5ess510nD3tai75
WebSession                     Microsoft.PowerShell.Commands.WebRequestSession
StartTime                      12/02/2024 22:58:13
ElapsedTime                    00:25:30
LastCommand                    System.Management.Automation.InvocationInfo
LastCommandTime                12/02/2024 23:23:07
LastCommandResults             {"success":true,"Result":{"SomeResult"}}
```

Output the IdentityCommand module scope session details, including the WebSession object for the current authenticated session.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

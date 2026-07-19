---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDUserOathOTPClientName

## SYNOPSIS
Get the tenant's OATH OTP client name

## SYNTAX

```
Get-IDUserOathOTPClientName [<CommonParameters>]
```

## DESCRIPTION
Retrieve the client/issuer name that CyberArk Identity presents to an OATH OTP authenticator app (such as Google Authenticator) when a user registers an OATH OTP device.

## EXAMPLES

### Example 1
```
PS C:\> Get-IDUserOathOTPClientName
```

Return the tenant's configured OATH OTP client name.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

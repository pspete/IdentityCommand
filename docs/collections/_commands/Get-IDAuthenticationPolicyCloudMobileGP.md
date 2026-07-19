---
external help file: IdentityCommand-help.xml
Module Name: IdentityCommand
online version:
schema: 2.0.0
---

# Get-IDAuthenticationPolicyCloudMobileGP

## SYNOPSIS
Get the tenant's cloud/mobile/group policy device management configuration

## SYNTAX

```
Get-IDAuthenticationPolicyCloudMobileGP [<CommonParameters>]
```

## DESCRIPTION
Retrieve the tenant's current device configuration policy source and settings, indicating whether CyberArk Identity Cloud Directory policy sets or Active Directory Group Policy are used to manage device configuration, along with related settings such as refresh/update intervals and mobile management forest binding.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-IDAuthenticationPolicyCloudMobileGP
```

Return the tenant's cloud/mobile/group policy device management configuration.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

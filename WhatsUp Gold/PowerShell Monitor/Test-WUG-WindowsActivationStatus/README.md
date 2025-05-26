# Test-WUG-WindowsActivationStatus.ps1

## ABOUT

### SHORT DESCRIPTION

    Tests whether Windows is licensed.

### LONG DESCRIPTION

    This script remotely connects to a Windows machine and retrieves the Windows Activation Status.

    It parses the LicenseStatus to determine if the machine is licensed.

    If the LicenseStatus is not equal to 1 (licensed), it will trigger the active monitor on the device.

## NOTE

    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.

    It is recommended to set a custom polling interval of 86400 seconds (24 hours) for this active monitor.

## CHANGELOG

[Link](./CHANGELOG.MD)

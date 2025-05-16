# Test-WUG-ArcCMAHeartbeat.ps1

## ABOUT

### SHORT DESCRIPTION

    Tests whether the setting 'Receive updates for other Microsoft Products when you updates Windows.' is enabled in Windows Update Settings.

### LONG DESCRIPTION

    This script remotely connects to a Windows machine and retrieves the Microsoft Update Service Manager Settings.

    It parses the IsDefaultAUService to determine if the setting is enabled.

    If the IsDefaultAUService is disabled (false), it will trigger the active monitor on the device.

## NOTE

    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.

    It is recommended to set a custom polling interval of 86400 seconds (24 hours) for this active monitor.

## CHANGELOG

[Link](./CHANGELOG.MD)

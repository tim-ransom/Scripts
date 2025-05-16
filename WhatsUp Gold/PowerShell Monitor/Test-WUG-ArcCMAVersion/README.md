# Test-WUG-ArcCMAHeartbeat.ps1

## ABOUT

### SHORT DESCRIPTION

    Tests whether the Azure Connected Machine agent version is within the defined threshold of the public release.

### LONG DESCRIPTION

    This script remotely connects to a Windows machine and retrieves the Azure Connected Machine agent (azcmagent) status via CLI.

    It parses the agentVersion and compares it to the current public version available.

    If the agentVersion is older than 2 minor versions, it will trigger the active monitor on the device.

## NOTE

    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.

    It is recommended to set a custom polling interval of 86400 seconds (24 hours) for this active monitor.

## CHANGELOG

[Link](./CHANGELOG.MD)

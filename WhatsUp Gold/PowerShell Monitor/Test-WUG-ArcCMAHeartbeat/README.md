# Test-WUG-ArcCMAHeartbeat.ps1

## ABOUT

### SHORT DESCRIPTION

    Tests whether the Azure Connected Machine agent has reported a heartbeat within the last 24 hours.

### LONG DESCRIPTION

    This script remotely connects to a Windows machine and retrieves the Azure Connected Machine agent (azcmagent) status via CLI.

    It parses the lastHeartbeat timestamp and compares it to the current time.

    If the heartbeat is older than 24 hours, it will trigger the active monitor on the device.

## NOTE

    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.

    It is recommended to set a custom polling interval of 86400 seconds (24 hours) for this active monitor.

## CHANGELOG

[Link](https://github.com/tim-ransom/Scripts/blob/main/WhatsUpGold/PowerShell%20Monitor/Test-WUG-ArcCMAHeartbeat/CHANGELOG.MD)

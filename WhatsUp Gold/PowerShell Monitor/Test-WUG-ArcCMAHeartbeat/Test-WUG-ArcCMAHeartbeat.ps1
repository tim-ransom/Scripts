<#
.SYNOPSIS
    Tests whether the Azure Connected Machine agent has reported a heartbeat within the last 24 hours.
.DESCRIPTION
    This script remotely connects to a Windows machine and retrieves the Azure Connected Machine agent (azcmagent) status via CLI.
    It parses the lastHeartbeat timestamp and compares it to the current time.
    If the heartbeat is older than 24 hours, it will trigger the active monitor on the device.
    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.
.NOTES
    Author:         Timothy Ransom
    Version:        1.0.0
    Version Date:   2025-05-16
    Website:        https://tim-ransom.github.io/

.LINK
    https://github.com/tim-ransom/Scripts/blob/main/WhatsUp%20Gold/PowerShell%20Monitor/Test-WUG-ArcCMAHeartbeat

#>

#Get device information
$IP = $Context.GetProperty("Address")

# Get the Windows credentials
$WinUser = $Context.GetProperty("CredWindows:DomainAndUserid");
$WinPass = $Context.GetProperty("CredWindows:Password");
$WinPassSecure = ConvertTo-SecureString $WinPass -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WinUser, $WinPassSecure

# Run CLI command on the remote device and capture the JSON output
$output = Invoke-Command -ComputerName $IP -ScriptBlock { azcmagent show -j | ConvertFrom-Json } -Credential $cred

# Parse the lastHeartbeat field into a DateTime object
$heartbeatDateTime = [datetime]::Parse($output.lastHeartbeat)
$now = Get-Date

# Check if the last heartbeat was more than 24 hours ago
$timeDifference = $now - $heartbeatDateTime

# Check if the timeDifference is greater than 24 hours.
if ($timeDifference.TotalHours -gt 24) {
    $HeartbeatMessage = "Last heartbeat was more than 24 hours ago. Heartbeat: $heartbeatDateTime."
    $Context.SetResult(1, $HeartbeatMessage)
} else {
    $HeartbeatMessage = "Last heartbeat is within the last 24 hours. Heartbeat: $heartbeatDateTime."
    $Context.SetResult(0, $HeartbeatMessage)
}

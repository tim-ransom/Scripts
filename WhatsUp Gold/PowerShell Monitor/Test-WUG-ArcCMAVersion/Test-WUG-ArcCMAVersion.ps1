<#
.SYNOPSIS
    Tests whether the Azure Connected Machine agent version is within the defined threshold of the public release.
.DESCRIPTION
    This script remotely connects to a Windows machine and retrieves the Azure Connected Machine agent (azcmagent) status via CLI.
    It parses the agentVersion and compares it to the current public version available.
    If the agentVersion is older than 2 minor versions, it will trigger the active monitor on the device.
    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.
.NOTES
    Author:         Timothy Ransom
    Version:        1.0.0
    Version Date:   2025-05-16
    Website:        https://tim-ransom.github.io/

.LINK
    https://github.com/Encore-Infra/Scripts/blob/main/WhatsUpGold/PowerShell%20Monitor/Test-WUG-ArcCMAVersion/Test-WUG-ArcCMAVersion.ps1
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

# Parse the agentVersion field into a System.Version object
$agentVersion = [System.Version]::Parse($output.agentVersion)

# Retrieve the latest version from the Web
$url = "https://learn.microsoft.com/en-us/azure/azure-arc/servers/agent-release-notes"
$PageContent = (Invoke-WebRequest -Uri $url -UseBasicParsing).Content
$VersionInfo = [regex]::Matches($PageContent, 'Version (\d+\.\d+) - ([A-Za-z]+ \d+)')
$LatestArcVersionFromWeb = $VersionInfo[0].Groups[1].Value
$LatestArcVersionFromWeb = [System.Version]::Parse($LatestArcVersionFromWeb)

# Minor Version Difference
$minorVersionDifference = $LatestArcVersionFromWeb.Minor - $agentVersion.Minor

# Version Difference Threshold
$Threshold = 2

# Evaluate version delta
if ($LatestArcVersionFromWeb.Major -eq $agentVersion.Major -and $minorVersionDifference -gt $Threshold) {
    $HeartbeatMessage = "Current Arc Agent Version $($agentVersion.Major).$($agentVersion.Minor) more than $Threshold minor versions behind. Current Version $($LatestArcVersionFromWeb)"
    $Context.SetResult(1, $HeartbeatMessage)
} else {
    $HeartbeatMessage = "Current Arc Agent Version $($agentVersion.Major).$($agentVersion.Minor) within threshold. Current Version $($LatestArcVersionFromWeb)"
    $Context.SetResult(0, $HeartbeatMessage)
}

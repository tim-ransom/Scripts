<#
.SYNOPSIS
    Tests whether the setting 'Receive updates for other Microsoft Products when you updates Windows.' is enabled in Windows Update Settings.
.DESCRIPTION
    This script remotely connects to a Windows machine and retrieves the Microsoft Update Service Manager Settings.
    It parses the IsDefaultAUService to determine if the setting is enabled.
    If the IsDefaultAUService is disabled (false), it will trigger the active monitor on the device.
    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.
.NOTES
    Author:         Timothy Ransom
    Version:        1.0.0
    Version Date:   2025-05-16
    Website:        https://tim-ransom.github.io/

.LINK
    https://github.com/tim-ransom/Scripts/blob/main/WhatsUpGold/PowerShell%20Monitor/Test-WUG-MSUpdateService/Test-WUG-MSUpdateService.ps1

#>

#Get device information
$IP = $Context.GetProperty("Address")

# Get the Windows credentials
$WinUser = $Context.GetProperty("CredWindows:DomainAndUserid");
$WinPass = $Context.GetProperty("CredWindows:Password");
$WinPassSecure = ConvertTo-SecureString $WinPass -asplaintext -force
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $WinUser, $WinPassSecure

# Run COM object query on remote machine and return simple status
$output = Invoke-Command -ComputerName $IP -ScriptBlock {
    $serviceManager = New-Object -ComObject "Microsoft.Update.ServiceManager"
    $msUpdateGuid = "7971f918-a847-4430-9279-4a52d1efe18d"

    $service = $serviceManager.Services | Where-Object { $_.ServiceID -eq $msUpdateGuid }
    if ($service) { $array = @($service) } else { $array = @() }

    return $array
} -Credential $cred


if ($output.IsDefaultAUService -eq $false) {
    $HeartbeatMessage = "The setting 'Receive updates for other Microsoft Products when you updates Windows.' is NOT enabled in Windows Update Settings."
    $Context.SetResult(1, $HeartbeatMessage)
} else {
    $HeartbeatMessage = "The setting 'Receive updates for other Microsoft Products when you updates Windows.' is enabled in Windows Update Settings."
    $Context.SetResult(0, $HeartbeatMessage)
}

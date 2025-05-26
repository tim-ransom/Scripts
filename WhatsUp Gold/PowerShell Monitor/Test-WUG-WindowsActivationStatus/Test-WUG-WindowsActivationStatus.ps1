<#
.SYNOPSIS
    Tests whether Windows is licensed.
.DESCRIPTION
    This script remotely connects to a Windows machine and retrieves the Windows Activation Status.
    It parses the LicenseStatus to determine if the machine is licensed.
    If the LicenseStatus is not equal to 1 (licensed), it will trigger the active monitor on the device.
    This script is intended to be used as a PowerShell Script Active Monitor in WhatsUp Gold.
.NOTES
    Author:         Timothy Ransom
    Version:        1.0.0
    Version Date:   2025-05-19
    Website:        https://tim-ransom.github.io/

.LINK
    https://github.com/tim-ransom/Scripts/blob/main/WhatsUp%20Gold/PowerShell%20Monitor/Test-WUG-WindowsActivationStatus

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
    Get-CimInstance SoftwareLicensingProduct -Filter "Name like 'Windows%'" | Where-Object { $_.PartialProductKey } | Select-Object LicenseStatus
} -Credential $cred


if ($output.LicenseStatus -ne 1) {
    $HeartbeatMessage = "Windows is currently unlicensed."
    $Context.SetResult(1, $HeartbeatMessage)
} else {
    $HeartbeatMessage = "Windows is licensed"
    $Context.SetResult(0, $HeartbeatMessage)
}

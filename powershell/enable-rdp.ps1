# https://tinyurl.com/oee-rdp
# One-click RDP setup: Run as Administrator and execute:
# PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-rdp.ps1' -OutFile '$env:TEMP\enable-rdp.ps1'; & '$env:TEMP\enable-rdp.ps1'"

# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}


# Enable Remote Desktop (sets fDenyTSConnections = 0)
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' `
  -Name 'fDenyTSConnections' -Value 0

  # Enable the built-in firewall rules for Remote Desktop
Enable-NetFirewallRule -DisplayGroup 'Remote Desktop'

# Confirm TermService is running
Get-Service -Name TermService | Start-Service

# Check the configured RDP port (default 3389)
(Get-ItemProperty 'HKLM:\System\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp').PortNumber

# Confirm firewall rules are enabled
Get-NetFirewallRule -DisplayGroup 'Remote Desktop' | Select-Object Name, Enabled
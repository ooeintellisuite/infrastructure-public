# One-Click RDP Setup

## Quick Setup (Single Command)

1. Right-click on PowerShell and select "Run as Administrator"
2. Copy and paste this command:

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-rdp.ps1' -OutFile '$env:TEMP\enable-rdp.ps1'; & '$env:TEMP\enable-rdp.ps1'"
```

3. Press Enter and wait for the script to complete

## What This Script Does

- Enables Remote Desktop (RDP) on the server
- Configures Windows Firewall to allow RDP connections
- Starts the Terminal Service if not already running
- Displays the RDP port number (default: 3389)
- Confirms firewall rules are enabled

## TinyURL Shortcut

For easier sharing, use this TinyURL:
[https://tinyurl.com/oee-rdp](https://tinyurl.com/oee-rdp)

This link will redirect to this page with the instructions above.

## Security Note

This script requires Administrator privileges to modify system settings. Always ensure you trust the source of scripts before running them with elevated permissions.

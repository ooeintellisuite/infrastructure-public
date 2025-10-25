# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# Enable WSL feature
Write-Host "Enabling Windows Subsystem for Linux feature..." -ForegroundColor Green
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform feature
Write-Host "Enabling Virtual Machine Platform feature..." -ForegroundColor Green
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Download and install WSL2 Linux kernel update package
Write-Host "Downloading WSL2 Linux kernel update package..." -ForegroundColor Green
$kernelUpdateUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$kernelUpdatePath = "$env:TEMP\wsl_update_x64.msi"
Invoke-WebRequest -Uri $kernelUpdateUrl -OutFile $kernelUpdatePath

Write-Host "Installing WSL2 Linux kernel update package..." -ForegroundColor Green
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$kernelUpdatePath`" /quiet" -Wait

# Set WSL2 as the default version
Write-Host "Setting WSL2 as the default version..." -ForegroundColor Green
wsl --set-default-version 2

# Install Ubuntu from Microsoft Store (this will open the Microsoft Store)
Write-Host "Installing Ubuntu from Microsoft Store..." -ForegroundColor Green
Write-Host "Note: This will open the Microsoft Store. Please click 'Get' or 'Install' on the Ubuntu page." -ForegroundColor Yellow
Start-Process "ms-windows-store://pdp/?productid=9NBLGGH4MSV6"

# Reboot prompt
Write-Host "WSL and Ubuntu installation setup completed." -ForegroundColor Green
Write-Host "A system reboot is required to complete the installation." -ForegroundColor Yellow
Write-Host "After rebooting, you can initialize Ubuntu by running 'ubuntu' from PowerShell or Command Prompt." -ForegroundColor Yellow

$reboot = Read-Host "Do you want to reboot now? (Y/N)"
if ($reboot -eq 'Y' -or $reboot -eq 'y') {
    Write-Host "Rebooting system in 10 seconds..." -ForegroundColor Red
    Start-Sleep -Seconds 10
    Restart-Computer
} else {
    Write-Host "Please remember to reboot your system to complete the installation." -ForegroundColor Yellow
}
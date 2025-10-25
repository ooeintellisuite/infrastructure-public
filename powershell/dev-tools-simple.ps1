# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# --- Install Chocolatey ---
Write-Host "Installing Chocolatey..." -ForegroundColor Green

Set-ExecutionPolicy Bypass -Scope Process -Force

$chocoInstalled = Get-Command choco -ErrorAction SilentlyContinue
if ($chocoInstalled) {
    Write-Host "Chocolatey is already installed." -ForegroundColor Green
} else {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# --- Verify Installation ---
if (Get-Command choco -ErrorAction SilentlyContinue) {
    Write-Host "Chocolatey installation successful." -ForegroundColor Green
} else {
    Write-Error "Chocolatey installation failed."
    exit
}

# Install Visual Studio Code
Write-Host "Installing Visual Studio Code..." -ForegroundColor Green
choco install vscode -y

# Install Azure Data Studio
Write-Host "Installing Azure Data Studio..." -ForegroundColor Green
choco install azure-data-studio -y

Write-Host "Visual Studio Code and Azure Data Studio installation completed." -ForegroundColor Green

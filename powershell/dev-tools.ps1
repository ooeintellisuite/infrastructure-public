# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# Install Visual Studio Code
Write-Host "Installing Visual Studio Code..." -ForegroundColor Green
choco install vscode -y

# Install Azure Data Studio
Write-Host "Installing Azure Data Studio..." -ForegroundColor Green
choco install azure-data-studio -y

Write-Host "Visual Studio Code and Azure Data Studio installation completed." -ForegroundColor Green

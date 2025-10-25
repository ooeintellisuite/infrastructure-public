# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# Install Git
Write-Host "Installing Git..." -ForegroundColor Green
choco install git -y

# Install Node.js
Write-Host "Installing Node.js..." -ForegroundColor Green
choco install nodejs -y

# Install pnpm
Write-Host "Installing pnpm..." -ForegroundColor Green
npm install -g pnpm

# Install Prisma CLI
Write-Host "Installing Prisma CLI..." -ForegroundColor Green
npm install -g prisma

# Install Python
Write-Host "Installing Python..." -ForegroundColor Green
choco install python -y

# Install DBeaver
Write-Host "Installing DBeaver..." -ForegroundColor Green
choco install dbeaver -y

# Install SQL Server Management Studio (SSMS)
Write-Host "Installing SQL Server Management Studio..." -ForegroundColor Green
choco install sql-server-management-studio -y

# Install Google Chrome
Write-Host "Installing Google Chrome..." -ForegroundColor Green
choco install googlechrome -y

# Install Docker Desktop
Write-Host "Installing Docker Desktop..." -ForegroundColor Green
choco install docker-desktop -y

# Install Postman
Write-Host "Installing Postman..." -ForegroundColor Green
choco install postman -y

# Install Visual Studio Code
Write-Host "Installing Visual Studio Code..." -ForegroundColor Green
choco install vscode -y

# Install Azure Data Studio
Write-Host "Installing Azure Data Studio..." -ForegroundColor Green
choco install azure-data-studio -y

Write-Host "All development tools installation completed." -ForegroundColor Green

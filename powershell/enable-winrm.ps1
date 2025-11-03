# One-click WinRM setup: Run as Administrator and execute:
# PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-winrm.ps1' -OutFile '$env:TEMP\enable-winrm.ps1'; & '$env:TEMP\enable-winrm.ps1'"

# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

Write-Host "Configuring WinRM for remote connections..." -ForegroundColor Green

# Check if WinRM is already running
$winrmService = Get-Service -Name WinRM -ErrorAction SilentlyContinue
if ($winrmService -and $winrmService.Status -eq 'Running') {
    Write-Host "WinRM service is already running." -ForegroundColor Yellow
} else {
    Write-Host "Starting WinRM service..." -ForegroundColor Green
    Start-Service -Name WinRM
}

# Enable WinRM with default settings
Write-Host "Enabling WinRM configuration..." -ForegroundColor Green
Enable-PSRemoting -Force

# Configure WinRM to allow remote connections
Write-Host "Configuring WinRM for remote access..." -ForegroundColor Green
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# Configure WinRM service for automatic start
Write-Host "Setting WinRM service to automatic start..." -ForegroundColor Green
Set-Service -Name WinRM -StartupType Automatic

# Configure firewall rules for WinRM
Write-Host "Configuring firewall rules for WinRM..." -ForegroundColor Green
Enable-NetFirewallRule -DisplayGroup "Windows Remote Management"

# Configure WinRM listener for HTTP (default port 5985)
Write-Host "Creating WinRM HTTP listener..." -ForegroundColor Green
$listener = Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTP" }
if (-not $listener) {
    New-Item -Path WSMan:\localhost\Listener -Transport HTTP -Address * -Force
}

# Configure WinRM listener for HTTPS (default port 5986) - optional
Write-Host "Creating WinRM HTTPS listener..." -ForegroundColor Green
$httpsListener = Get-ChildItem WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTPS" }
if (-not $httpsListener) {
    # Note: For HTTPS listener, you need to have a valid certificate
    # This will create a self-signed certificate for testing purposes
    $cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My
    New-Item -Path WSMan:\localhost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint -Force
}

# Display WinRM configuration
Write-Host "Current WinRM configuration:" -ForegroundColor Green
Get-ChildItem WSMan:\localhost\Listener

# Test WinRM configuration
Write-Host "Testing WinRM configuration..." -ForegroundColor Green
try {
    Test-WSMan -ComputerName localhost
    Write-Host "WinRM configuration successful!" -ForegroundColor Green
} catch {
    Write-Error "WinRM configuration failed: $_"
    exit 1
}

Write-Host "WinRM has been enabled and configured for remote connections." -ForegroundColor Green
Write-Host "You can now connect to this computer using:" -ForegroundColor Cyan
Write-Host "  Enter-PSSession -ComputerName $env:COMPUTERNAME" -ForegroundColor Cyan
Write-Host "  or" -ForegroundColor Cyan
Write-Host "  Invoke-Command -ComputerName $env:COMPUTERNAME -ScriptBlock { Get-Process }" -ForegroundColor Cyan
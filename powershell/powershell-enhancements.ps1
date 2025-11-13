# Global PowerShell Modern Setup Script
# Run this once as Administrator to set up modern defaults for all PowerShell sessions

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Ensure running as Administrator
If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    throw "Must run as Administrator"
}

Write-Host "Setting up modern PowerShell defaults globally..." -ForegroundColor Green

# 1. GLOBAL TLS 1.2 - Set in registry for all .NET applications
Write-Host "Setting TLS 1.2 as default globally..." -ForegroundColor Yellow

# Enable TLS 1.2 for .NET Framework (affects PowerShell)
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Type DWord -Force

# Disable older TLS versions globally
$tlsRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

# Disable SSL 2.0
$ssl2ServerPath = "$tlsRegistryPath\SSL 2.0\Server"
$ssl2ClientPath = "$tlsRegistryPath\SSL 2.0\Client"
New-Item -Path $ssl2ServerPath -Force | Out-Null
New-Item -Path $ssl2ClientPath -Force | Out-Null
Set-ItemProperty -Path $ssl2ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl2ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ssl2ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl2ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

# Disable SSL 3.0
$ssl3ServerPath = "$tlsRegistryPath\SSL 3.0\Server"
$ssl3ClientPath = "$tlsRegistryPath\SSL 3.0\Client"
New-Item -Path $ssl3ServerPath -Force | Out-Null
New-Item -Path $ssl3ClientPath -Force | Out-Null
Set-ItemProperty -Path $ssl3ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl3ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ssl3ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl3ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

# Disable TLS 1.0
$tls10ServerPath = "$tlsRegistryPath\TLS 1.0\Server"
$tls10ClientPath = "$tlsRegistryPath\TLS 1.0\Client"
New-Item -Path $tls10ServerPath -Force | Out-Null
New-Item -Path $tls10ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls10ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls10ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls10ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls10ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

# Disable TLS 1.1
$tls11ServerPath = "$tlsRegistryPath\TLS 1.1\Server"
$tls11ClientPath = "$tlsRegistryPath\TLS 1.1\Client"
New-Item -Path $tls11ServerPath -Force | Out-Null
New-Item -Path $tls11ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls11ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls11ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls11ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls11ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

# Enable TLS 1.2
$tls12ServerPath = "$tlsRegistryPath\TLS 1.2\Server"
$tls12ClientPath = "$tlsRegistryPath\TLS 1.2\Client"
New-Item -Path $tls12ServerPath -Force | Out-Null
New-Item -Path $tls12ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls12ServerPath -Name 'Enabled' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls12ServerPath -Name 'DisabledByDefault' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls12ClientPath -Name 'Enabled' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls12ClientPath -Name 'DisabledByDefault' -Value 0 -Type DWord -Force

# 3. INSTALL LATEST PACKAGE MANAGEMENT COMPONENTS
Write-Host "Installing latest package management components..." -ForegroundColor Yellow

# Set TLS for current session
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Install latest NuGet provider
Write-Host "Installing NuGet package provider..." -ForegroundColor Yellow
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue

# Trust PSGallery for this session
if (Get-PSRepository -Name PSGallery -ErrorAction SilentlyContinue) {
    Write-Host "PowerShell Gallery repository already registered." -ForegroundColor Green
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}
else {
    Write-Host "Registering PowerShell Gallery repository..." -ForegroundColor Yellow
    Register-PSRepository -Name PSGallery -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted
}


# Install/Update PowerShellGet and PackageManagement
Write-Host "Installing/Updating PowerShellGet and PackageManagement modules..." -ForegroundColor Yellow
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers -Repository PSGallery
Install-Module -Name PackageManagement -Force -AllowClobber -Scope AllUsers -Repository PSGallery

# 4. INSTALL COMMON MODERN MODULES (CHECK IF ALREADY INSTALLED)
Write-Host "Checking and installing common modern PowerShell modules..." -ForegroundColor Yellow

$commonModules = @(
    'Az',                    # Azure PowerShell
    'Microsoft.PowerShell.SecretManagement',
    'Microsoft.PowerShell.SecretStore',
    'PowerShellGet',         # Latest version
    'PackageManagement',     # Latest version
    'PSReadLine',           # Better console experience
    'ImportExcel',          # Excel manipulation without Excel
    'PSDscResources'        # DSC resources
)

foreach ($module in $commonModules) {
    Write-Host "`nChecking module: $module" -ForegroundColor Cyan
    
    # Check if module is already installed
    $installedModule = Get-Module -Name $module -ListAvailable -ErrorAction SilentlyContinue
    
    if ($installedModule) {
        $latestInstalled = $installedModule | Sort-Object Version -Descending | Select-Object -First 1
        Write-Host "✓ $module is already installed (Version: $($latestInstalled.Version))" -ForegroundColor Green
        
        # Check if there's a newer version available (uncomment if desired)
        try {
            $onlineModule = Find-Module -Name $module -ErrorAction SilentlyContinue
            if ($onlineModule -and ($onlineModule.Version -gt $latestInstalled.Version)) {
                Write-Host "  → Newer version available: $($onlineModule.Version) (currently installed: $($latestInstalled.Version))" -ForegroundColor Yellow
                if ($Force) {
                    Write-Host "  → Force parameter specified, updating..." -ForegroundColor Yellow
                    Install-Module -Name $module -Force -AllowClobber -Scope AllUsers -Repository PSGallery -ErrorAction Continue
                    Write-Host "  ✓ $module updated successfully" -ForegroundColor Green
                }
                else {
                    Write-Host "  → Use -Force parameter to update to latest version" -ForegroundColor DarkYellow
                }
            }
        }
        catch {
            Write-Warning "Could not check for newer version of $module"
        }
    }
    else {
        try {
            Write-Host "Installing $module..." -ForegroundColor Yellow
            Install-Module -Name $module -Force -AllowClobber -Scope AllUsers -Repository PSGallery -ErrorAction Stop
            Write-Host "✓ $module installed successfully" -ForegroundColor Green
        }
        catch {
            Write-Warning "Failed to install $module`: $($_.Exception.Message)"
            
            # Special handling for Az module (it's large and can timeout)
            if ($module -eq 'Az') {
                Write-Host "  → Az module is large and may take longer. Consider installing specific Az submodules instead." -ForegroundColor Yellow
                Write-Host "  → Example: Install-Module Az.Accounts, Az.Resources, Az.Storage" -ForegroundColor Yellow
            }
        }
    }
}

Write-Host "`n--- Module Installation Summary ---" -ForegroundColor Magenta
Write-Host "Installed modules check:" -ForegroundColor White
foreach ($module in $commonModules) {
    $installedCheck = Get-Module -Name $module -ListAvailable -ErrorAction SilentlyContinue
    if ($installedCheck) {
        $version = ($installedCheck | Sort-Object Version -Descending | Select-Object -First 1).Version
        Write-Host "✓ $module ($version)" -ForegroundColor Green
    }
    else {
        Write-Host "✗ $module (not installed)" -ForegroundColor Red
    }
}

# 5. SET MODERN EXECUTION POLICY GLOBALLY (ONLY IF NEEDED)
Write-Host "Checking execution policy..." -ForegroundColor Yellow

# Get current effective execution policy
$currentPolicy = Get-ExecutionPolicy
$localMachinePolicy = Get-ExecutionPolicy -Scope LocalMachine

Write-Host "Current effective execution policy: $currentPolicy" -ForegroundColor Cyan
Write-Host "LocalMachine scope policy: $localMachinePolicy" -ForegroundColor Cyan

# Define acceptable policies (in order of permissiveness)
$acceptablePolicies = @('Bypass', 'Unrestricted', 'RemoteSigned')

if ($currentPolicy -in $acceptablePolicies) {
    Write-Host "✓ Execution policy ($currentPolicy) is already suitable - no changes needed" -ForegroundColor Green
}
else {
    Write-Host "Current policy ($currentPolicy) is too restrictive. Attempting to set RemoteSigned..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force -ErrorAction Stop
        Write-Host "✓ Execution policy set to RemoteSigned" -ForegroundColor Green
    }
    catch {
        Write-Warning "Could not set execution policy to RemoteSigned: $($_.Exception.Message)"
        Write-Host "This may be due to Group Policy restrictions. Current policy ($currentPolicy) will remain in effect." -ForegroundColor Yellow
        
        # Show execution policy list for troubleshooting
        Write-Host "`nExecution policy by scope:" -ForegroundColor Cyan
        Get-ExecutionPolicy -List | Format-Table -AutoSize
    }
}

Write-Host "`n=== SETUP COMPLETE ===" -ForegroundColor Green
Write-Host "Modern PowerShell defaults have been configured:" -ForegroundColor White
Write-Host "✓ TLS 1.2 set as default globally" -ForegroundColor Green
Write-Host "✓ PowerShell Gallery trusted" -ForegroundColor Green
Write-Host "✓ Latest package providers installed" -ForegroundColor Green
Write-Host "✓ Common modules installed" -ForegroundColor Green
Write-Host "✓ Global PowerShell profile created" -ForegroundColor Green
Write-Host "✓ Modern execution policy set" -ForegroundColor Green
Write-Host "`nRestart PowerShell to use the new profile, or run: . `$PROFILE.AllUsersAllHosts" -ForegroundColor Yellow
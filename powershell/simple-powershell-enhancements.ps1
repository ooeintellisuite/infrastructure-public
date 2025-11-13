$ErrorActionPreference = "Stop"

Write-Host "Setting up modern PowerShell defaults globally..." -ForegroundColor Green

Write-Host "Setting TLS 1.2 as default globally..." -ForegroundColor Yellow

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Type DWord -Force
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value 1 -Type DWord -Force

$tlsRegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols"

$ssl2ServerPath = "$tlsRegistryPath\SSL 2.0\Server"
$ssl2ClientPath = "$tlsRegistryPath\SSL 2.0\Client"
New-Item -Path $ssl2ServerPath -Force | Out-Null
New-Item -Path $ssl2ClientPath -Force | Out-Null
Set-ItemProperty -Path $ssl2ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl2ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ssl2ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl2ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

$ssl3ServerPath = "$tlsRegistryPath\SSL 3.0\Server"
$ssl3ClientPath = "$tlsRegistryPath\SSL 3.0\Client"
New-Item -Path $ssl3ServerPath -Force | Out-Null
New-Item -Path $ssl3ClientPath -Force | Out-Null
Set-ItemProperty -Path $ssl3ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl3ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $ssl3ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $ssl3ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

$tls10ServerPath = "$tlsRegistryPath\TLS 1.0\Server"
$tls10ClientPath = "$tlsRegistryPath\TLS 1.0\Client"
New-Item -Path $tls10ServerPath -Force | Out-Null
New-Item -Path $tls10ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls10ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls10ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls10ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls10ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

$tls11ServerPath = "$tlsRegistryPath\TLS 1.1\Server"
$tls11ClientPath = "$tlsRegistryPath\TLS 1.1\Client"
New-Item -Path $tls11ServerPath -Force | Out-Null
New-Item -Path $tls11ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls11ServerPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls11ServerPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls11ClientPath -Name 'Enabled' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls11ClientPath -Name 'DisabledByDefault' -Value 1 -Type DWord -Force

$tls12ServerPath = "$tlsRegistryPath\TLS 1.2\Server"
$tls12ClientPath = "$tlsRegistryPath\TLS 1.2\Client"
New-Item -Path $tls12ServerPath -Force | Out-Null
New-Item -Path $tls12ClientPath -Force | Out-Null
Set-ItemProperty -Path $tls12ServerPath -Name 'Enabled' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls12ServerPath -Name 'DisabledByDefault' -Value 0 -Type DWord -Force
Set-ItemProperty -Path $tls12ClientPath -Name 'Enabled' -Value 1 -Type DWord -Force
Set-ItemProperty -Path $tls12ClientPath -Name 'DisabledByDefault' -Value 0 -Type DWord -Force

Write-Host "Installing latest package management components..." -ForegroundColor Yellow

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Write-Host "Installing NuGet package provider..." -ForegroundColor Yellow
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force -ErrorAction SilentlyContinue


    Write-Host "Registering PowerShell Gallery repository..." -ForegroundColor Yellow
    Register-PSRepository -Name PSGallery -SourceLocation "https://www.powershellgallery.com/api/v2" -InstallationPolicy Trusted

Write-Host "Installing/Updating PowerShellGet and PackageManagement modules..." -ForegroundColor Yellow
Install-Module -Name PowerShellGet -Force -AllowClobber -Scope AllUsers -Repository PSGallery
Install-Module -Name PackageManagement -Force -AllowClobber -Scope AllUsers -Repository PSGallery

Write-Host "Checking execution policy..." -ForegroundColor Yellow

Set-ExecutionPolicy RemoteSigned -Scope LocalMachine -Force -ErrorAction Stop
        Write-Host "Execution policy set to RemoteSigned" -ForegroundColor Green


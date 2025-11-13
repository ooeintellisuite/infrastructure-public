https://tinyurl.com/oee-iac

# Linux/Ansible Scripts

## Podman Installation

```bash
ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git   -C main   -i ansible/inventory   --ask-become-pass   ansible/podman-install.yml
```

## Docker Installation

```bash
ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git   -C main   -i ansible/inventory   --ask-become-pass   ansible/docker-install.yml
```

## Docker Installation with Ansible Setup

```bash
sudo apt update && sudo apt install -y ansible && ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git -C main ansible/docker-install.yml
```

# Windows PowerShell Scripts

## Enable Remote Desktop Protocol (RDP)

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-rdp.ps1' -OutFile '$env:TEMP\enable-rdp.ps1'; & '$env:TEMP\enable-rdp.ps1'"
```

## Install Full Development Tools Suite

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/dev-tools-full.ps1' -OutFile '$env:TEMP\dev-tools-full.ps1'; & '$env:TEMP\dev-tools-full.ps1'"
```

## Install Windows Subsystem for Linux (WSL) with Ubuntu

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/install-wsl-ubuntu.ps1' -OutFile '$env:TEMP\install-wsl-ubuntu.ps1'; & '$env:TEMP\install-wsl-ubuntu.ps1'"
```

## Add RDP User Account

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/add-rdp-user.ps1' -OutFile '$env:TEMP\add-rdp-user.ps1'; & '$env:TEMP\add-rdp-user.ps1' -Username 'yourusername' -Password ''"
```

## Install Chocolatey Package Manager

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/install-choco.ps1' -OutFile '$env:TEMP\install-choco.ps1'; & '$env:TEMP\install-choco.ps1'"
```

## Install Simple Development Tools

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/dev-tools-simple.ps1' -OutFile '$env:TEMP\dev-tools-simple.ps1'; & '$env:TEMP\dev-tools-simple.ps1'"
```

## Install Development Tools Follow-up

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/dev-tools-followup.ps1' -OutFile '$env:TEMP\dev-tools-followup.ps1'; & '$env:TEMP\dev-tools-followup.ps1'"
```

## Enable Windows Remote Management (WinRM)

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-winrm.ps1' -OutFile '$env:TEMP\enable-winrm.ps1'; & '$env:TEMP\enable-winrm.ps1'"
```

## PowerShell Enhancements and Modern Setup

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/powershell-enhancements.ps1' -OutFile '$env:TEMP\powershell-enhancements.ps1'; & '$env:TEMP\powershell-enhancements.ps1'"
```

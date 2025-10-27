https://tinyurl.com/oee-iac

```bash
ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git   -C main   -i ansible/inventory   --ask-become-pass   ansible/podman-install.yml
```

```bash
ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git   -C main   -i ansible/inventory   --ask-become-pass   ansible/docker-install.yml
```

```bash
sudo apt update && sudo apt install -y ansible && ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git -C main ansible/docker-install.yml
```

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/enable-rdp.ps1' -OutFile '$env:TEMP\enable-rdp.ps1'; & '$env:TEMP\enable-rdp.ps1'"
```

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/dev-tools-full.ps1' -OutFile '$env:TEMP\dev-tools-full.ps1'; & '$env:TEMP\dev-tools-full.ps1'"
```

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/install-wsl-ubuntu.ps1' -OutFile '$env:TEMP\install-wsl-ubuntu.ps1'; & '$env:TEMP\install-wsl-ubuntu.ps1'"
```

```powershell
PowerShell.exe -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/ooeintellisuite/infrastructure-public/main/powershell/add-rdp-user.ps1' -OutFile '$env:TEMP\add-rdp-user.ps1'; & '$env:TEMP\add-rdp-user.ps1' -Username 'yourusername' -Password ''"
```

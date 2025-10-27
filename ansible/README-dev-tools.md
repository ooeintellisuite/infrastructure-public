# Development Tools Installation with Ansible

This directory contains Ansible playbooks for installing development tools across different platforms, equivalent to PowerShell scripts `dev-tools-full.ps1` and `dev-tools-followup.ps1`.

## Available Playbooks

### 1. `dev-tools-full.yml`

- **Target Platform**: Ubuntu 25 (and other Debian-based distributions)
- **Purpose**: Installs development tools specifically for Ubuntu/Linux systems
- **Windows-specific tools**: Not installed (with alternatives provided)

### 2. `dev-tools-full-cross-platform.yml`

- **Target Platforms**: Ubuntu 25+ and Windows 10/11
- **Purpose**: Installs appropriate development tools based on the detected platform
- **Windows-specific tools**: Installed on Windows, alternatives on Linux

### 3. `dev-tools-followup.yml`

- **Target Platforms**: Ubuntu 25+ and Windows 10/11
- **Purpose**: Installs additional development tools and VS Code extensions
- **Includes**: pnpm, Prisma CLI, and a comprehensive set of VS Code extensions

## Tools Installed

### Common Tools (Both Platforms)

- **Git** - Version control system
- **Node.js** - JavaScript runtime
- **Python** - Programming language
- **DBeaver** - Universal database tool
- **Google Chrome** - Web browser
- **Postman** - API development tool
- **Visual Studio Code** - Code editor
- **Azure Data Studio** - Cross-platform SQL management tool

### Platform-Specific Tools

#### Ubuntu/Linux

- Note: Docker installation is handled separately via `docker-install.yml`

#### Windows

- **SQL Server Management Studio (SSMS)** - SQL Server management (Windows-only)

### Follow-up Tools (Both Platforms)

- **pnpm** - Fast, disk space efficient package manager
- **Prisma CLI** - Database toolkit for TypeScript and Node.js

### VS Code Extensions (Follow-up)

- **streetsidesoftware.code-spell-checker** - Spell checker
- **esbenp.prettier-vscode** - Code formatter
- **CucumberOpen.cucumber-official** - Cucumber support
- **vivaxy.vscode-conventional-commits** - Conventional commits
- **redhat.vscode-yaml** - YAML support
- **redhat.vscode-xml** - XML support
- **ms-python.python** - Python support
- **ms-python.black-formatter** - Python formatter
- **ms-python.debugpy** - Python debugger
- **ms-python.vscode-pylance** - Python language server
- **vitest.explorer** - Vitest testing
- **dbaeumer.vscode-eslint** - JavaScript linter
- **dsznajder.es7-react-js-snippets** - React snippets
- **Prisma.prisma** - Prisma support

## Usage

### Prerequisites

- Ansible installed on the control machine
- For Ubuntu: `sudo` access for package installation
- For Windows: Administrator privileges for Chocolatey package installation

### Running the Playbooks

#### For Ubuntu/Debian Systems:

```bash
# Ubuntu-specific playbook
ansible-playbook dev-tools-full.yml

# Cross-platform playbook (will detect Ubuntu)
ansible-playbook dev-tools-full-cross-platform.yml

# Follow-up tools and extensions
ansible-playbook dev-tools-followup.yml
```

#### For Windows Systems:

```powershell
# Cross-platform playbook (will detect Windows)
ansible-playbook dev-tools-full-cross-platform.yml

# Follow-up tools and extensions
ansible-playbook dev-tools-followup.yml
```

## Platform-Specific Notes

### Ubuntu/Linux

- SSMS is not available on Linux; Azure Data Studio is provided as an alternative
- Tools are installed using native package managers (apt) and direct downloads
- Docker installation is handled separately via `docker-install.yml`

### Windows

- Chocolatey is installed as package manager if not present
- All tools are installed via Chocolatey packages
- SSMS is available and installed

## Post-Installation

### Ubuntu/Linux

1. Some tools may require a system restart or logout/login to work properly
2. Check the installation summary at `~/dev-tools-installation-summary.txt`
3. Check the follow-up installation summary at `~/dev-tools/dev-tools-followup-summary.txt`

### Windows

1. Some tools may require a system restart
2. Check the installation summary at `~/dev-tools/dev-tools-installation-summary.txt`
3. Check the follow-up installation summary at `~/dev-tools/dev-tools-followup-summary.txt`

## Troubleshooting

### Ubuntu/Linux

- If package installation fails, ensure the system is fully updated: `sudo apt update && sudo apt upgrade`

### Windows

- Ensure PowerShell is running as Administrator
- If Chocolatey installation fails, check execution policy: `Set-ExecutionPolicy Bypass -Scope Process -Force`
- Some tools may require .NET Framework or Visual C++ redistributables

## Customization

To modify the tools installed:

1. Edit the appropriate playbook file
2. Add or remove tasks as needed
3. For Ubuntu: Modify apt package lists or download URLs
4. For Windows: Modify Chocolatey package names

## Security Considerations

- These playbooks install software from external repositories
- Review the sources of packages before running in production environments
- Consider using version pinning for reproducible deployments
- Some tools may require additional security configuration

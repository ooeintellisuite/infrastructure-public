# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# Install node-gyp (required for native modules like sqlite3)
Write-Host "Installing node-gyp..." -ForegroundColor Green
npm install -g node-gyp

# Install pnpm
Write-Host "Installing pnpm..." -ForegroundColor Green
npm install -g pnpm

# Install Prisma CLI
Write-Host "Installing Prisma CLI..." -ForegroundColor Green
npm install -g prisma

$extensions = @(
    "streetsidesoftware.code-spell-checker",
    "esbenp.prettier-vscode",
    "CucumberOpen.cucumber-official",
    "vivaxy.vscode-conventional-commits",
    "redhat.vscode-yaml",
    "redhat.vscode-xml",
    "ms-python.python",
    "ms-python.black-formatter",
    "ms-python.debugpy",
    "ms-python.vscode-pylance",
    "vitest.explorer",
    "dbaeumer.vscode-eslint",
    "dsznajder.es7-react-js-snippets",
    "Prisma.prisma"
)

$systemExtensionsDir = "$env:ProgramFiles\Microsoft VS Code\resources\app\extensions"

foreach ($extension in $extensions) {
    code --extensions-dir $systemExtensionsDir --install-extension $extension --force
}
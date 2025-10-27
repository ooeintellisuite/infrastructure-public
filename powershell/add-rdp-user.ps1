param(
    [Parameter(Mandatory=$true)]
    [string]$Username,
    
    [Parameter(Mandatory=$true)]
    [string]$Password
)

# --- Pre-check for Administrator privileges ---
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run with Administrator privileges. Please right-click and 'Run as Administrator'."
    exit 1
}

# Convert password to secure string
$securePassword = ConvertTo-SecureString $Password -AsPlainText -Force

# --- Create User Account ---
Write-Host "Creating user account: $Username" -ForegroundColor Green

# Check if user already exists
if (Get-LocalUser -Name $Username -ErrorAction SilentlyContinue) {
    Write-Warning "User '$Username' already exists. Updating password and group memberships."
    Set-LocalUser -Name $Username -PasswordNeverExpires $true -Password $securePassword
} else {
    # Create new local user
    New-LocalUser -Name $Username -Password $securePassword -PasswordNeverExpires -Description "Development user for RDP access"
    Write-Host "User '$Username' created successfully." -ForegroundColor Green
}

# --- Add User to Required Groups ---
Write-Host "Adding user to required groups..." -ForegroundColor Green

# Add to Users group (basic user permissions) - this is done automatically when creating a user
try {
    Add-LocalGroupMember -Group "Users" -Member $Username -ErrorAction SilentlyContinue
} catch {
    # User is likely already in this group
}

# Add to Remote Desktop Users group for RDP access
try {
    Add-LocalGroupMember -Group "Remote Desktop Users" -Member $Username
    Write-Host "Added to Remote Desktop Users group." -ForegroundColor Green
} catch {
    Write-Host "User already in Remote Desktop Users group." -ForegroundColor Yellow
}

# Add to docker-users group if exists (for Docker Desktop access)
if (Get-LocalGroup -Name "docker-users" -ErrorAction SilentlyContinue) {
    try {
        Add-LocalGroupMember -Group "docker-users" -Member $Username
        Write-Host "Added to docker-users group." -ForegroundColor Green
    } catch {
        Write-Host "User already in docker-users group." -ForegroundColor Yellow
    }
} else {
    Write-Host "docker-users group not found (Docker may not be installed)." -ForegroundColor Yellow
}

# --- Final Configuration ---
Write-Host "Finalizing user configuration..." -ForegroundColor Green

# Set user account to never expire
Set-LocalUser -Name $Username -PasswordNeverExpires $true

# Enable user account if disabled
Enable-LocalUser -Name $Username

# Display user information
$userInfo = Get-LocalUser -Name $Username
Write-Host "User account created/updated successfully:" -ForegroundColor Green
Write-Host "Username: $($userInfo.Name)" -ForegroundColor Green
Write-Host "Description: $($userInfo.Description)" -ForegroundColor Green
Write-Host "Account Enabled: $($userInfo.Enabled)" -ForegroundColor Green
Write-Host "Password Expires: $($userInfo.PasswordExpires)" -ForegroundColor Green

# Display group memberships
Write-Host "`nGroup Memberships:" -ForegroundColor Green
try {
    $userSID = (Get-LocalUser -Name $Username).SID
    $userGroups = Get-LocalGroup | Where-Object {
        try {
            $members = Get-LocalGroupMember -Group $_.Name -ErrorAction SilentlyContinue
            $members.SID -contains $userSID
        } catch {
            $false
        }
    }
    foreach ($group in $userGroups) {
        Write-Host "  - $($group.Name)" -ForegroundColor Green
    }
} catch {
    Write-Host "Could not retrieve group memberships." -ForegroundColor Yellow
}

Write-Host "`nUser setup completed successfully!" -ForegroundColor Green
Write-Host "The user can now RDP to this machine and use the pre-installed development tools." -ForegroundColor Green
#!/usr/bin/env fish

# Script to connect to a Windows machine via WinRM and change the Administrator password
# Usage: ./change-admin-password-winrm.fish <hostname> <username> <current_password> <new_password>

# Check if required arguments are provided
if test (count $argv) -ne 4
    echo "Usage: $argv[1] <hostname> <username> <current_password> <new_password>"
    echo "Example: $argv[1] 192.168.1.100 Administrator oldPassword newPassword123!"
    exit 1
end

set HOSTNAME $argv[1]
set USERNAME $argv[2]
set CURRENT_PASSWORD $argv[3]
set NEW_PASSWORD $argv[4]

# Check if winrm command is available
if not command -v winrm >/dev/null 2>&1
    echo "Error: winrm command not found."
    echo "Please install the WinRM client tools:"
    echo "  - On Ubuntu/Debian: sudo apt-get install winrm"
    echo "  - On CentOS/RHEL: sudo yum install winrm"
    echo "  - On macOS: brew install winrm"
    exit 1
end

echo "Connecting to $HOSTNAME via WinRM to change password for $USERNAME..."

# PowerShell command to change the password
set POWERHELL_COMMAND "net user $USERNAME '$NEW_PASSWORD'"

# Execute the command via WinRM
echo "Executing password change command..."
winrm -hostname "$HOSTNAME" -username "$USERNAME" -password "$CURRENT_PASSWORD" -cmd "$POWERHELL_COMMAND"

# Check the exit status
if test $status -eq 0
    echo "Password change completed successfully!"
    echo "The new password for $USERNAME on $HOSTNAME has been set."
else
    echo "Error: Failed to change password."
    echo "Please check:"
    echo "  - Network connectivity to $HOSTNAME"
    echo "  - WinRM is enabled on the target machine"
    echo "  - Correct credentials were provided"
    echo "  - The new password meets complexity requirements"
    exit 1
end

# Test the new password by running a simple command
echo "Verifying the new password..."
set TEST_COMMAND "whoami"
winrm -hostname "$HOSTNAME" -username "$USERNAME" -password "$NEW_PASSWORD" -cmd "$TEST_COMMAND"

if test $status -eq 0
    echo "Password verification successful!"
else
    echo "Warning: Password verification failed. The password might not have been changed correctly."
    exit 1
end
#!/bin/bash

# Script to connect to a Windows machine via WinRM and change the Administrator password
# Usage: ./change-admin-password-winrm.sh <hostname> <username> <current_password> <new_password>

# Check if required arguments are provided
if [ "$#" -ne 4 ]; then
    echo "Usage: $0 <hostname> <username> <current_password> <new_password>"
    echo "Example: $0 192.168.1.100 Administrator oldps newps"
    exit 1
fi

HOSTNAME=$1
USERNAME=$2
CURRENT_PASSWORD=$3
NEW_PASSWORD=$4

# Check if winrm command is available
if ! command -v winrm &> /dev/null; then
    echo "Error: winrm command not found."
    echo "Please install the WinRM client tools:"
    echo "  - On Ubuntu/Debian: sudo apt-get install winrm"
    echo "  - On CentOS/RHEL: sudo yum install winrm"
    echo "  - On macOS: brew install winrm"
    exit 1
fi

echo "Connecting to $HOSTNAME via WinRM to change password for $USERNAME..."

# PowerShell command to change the password
POWERHELL_COMMAND="net user $USERNAME '$NEW_PASSWORD'"

# Execute the command via WinRM
echo "Executing password change command..."
winrm -hostname "$HOSTNAME" -username "$USERNAME" -password "$CURRENT_PASSWORD" -cmd "$POWERHELL_COMMAND"

# Check the exit status
if [ $? -eq 0 ]; then
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
fi

# Test the new password by running a simple command
echo "Verifying the new password..."
TEST_COMMAND="whoami"
winrm -hostname "$HOSTNAME" -username "$USERNAME" -password "$NEW_PASSWORD" -cmd "$TEST_COMMAND"

if [ $? -eq 0 ]; then
    echo "Password verification successful!"
else
    echo "Warning: Password verification failed. The password might not have been changed correctly."
    exit 1
fi
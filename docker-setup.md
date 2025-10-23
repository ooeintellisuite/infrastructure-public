# One-Click Docker Setup for Linux

## Quick Setup (Single Command)

1. Open a terminal on your Ubuntu/Debian system
2. Copy and paste this command:

```bash
sudo apt update && sudo apt install -y ansible && ansible-pull -U https://github.com/ooeintellisuite/infrastructure-public.git -C main ansible/docker-install.yml --connection=local
```

3. Press Enter and wait for the installation to complete

## What This Script Does

- Installs Ansible package manager
- Downloads and runs the Docker installation playbook from the repository
- Installs Docker Engine with all latest packages
- Configures Docker daemon with optimal settings
- Adds your user to the docker group
- Sets up Docker environment variables
- Creates a weekly cleanup cron job
- Verifies the installation

## What Gets Installed

- Docker Engine (docker-ce, docker-ce-cli, containerd.io)
- Docker Buildx plugin
- Docker Compose plugin
- Proper Docker daemon configuration with logging limits
- User permissions to run Docker without sudo

## TinyURL Shortcut

For easier sharing, use this TinyURL:
[https://tinyurl.com/oee-docker](https://tinyurl.com/oee-docker)

This link will redirect to this page with the instructions above.

## After Installation

1. Log out and log back in to apply group membership changes
2. Verify Docker is working: `docker --version`
3. Verify Docker Compose is working: `docker compose version`
4. Test Docker: `docker run hello-world`

## Security Note

This command requires sudo privileges to install packages and configure Docker. Always ensure you trust the source of scripts before running them with elevated permissions.

## About Ansible Pull

This setup uses `ansible-pull` which:

- Pulls the playbook directly from the GitHub repository
- Runs the playbook locally without needing an inventory file
- Uses `--connection=local` to target the local machine
- Always fetches the latest version of the playbook when run

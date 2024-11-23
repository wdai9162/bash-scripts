#!/bin/bash

# Define the log file
LOG_FILE="/tmp/bootstrap.log"

# Redirect all output and errors to the log file
exec > >(tee -a $LOG_FILE) 2>&1

echo "Starting the bootstrap script..."

# Check if sudo is available, otherwise define it as a no-op
if ! command -v sudo &> /dev/null; then
    sudo() { "$@"; }
fi

# Check if hostname is provided as an environment variable, otherwise prompt for it
if [ -z "$NEW_HOSTNAME" ]; then
  echo "Please enter the new hostname: "
  read NEW_HOSTNAME
fi

# Set the hostname
echo "Setting the new hostname to $NEW_HOSTNAME..."
sudo hostnamectl set-hostname "$NEW_HOSTNAME"

# Update the /etc/hosts file to reflect the new hostname
echo "Updating /etc/hosts with the new hostname..."
sudo sed -i "s/127.0.1.1 .*/127.0.1.1 $NEW_HOSTNAME/" /etc/hosts

# Update the package list and upgrade the system
echo "Updating and upgrading the system..."
sudo apt update && sudo apt upgrade -y

# Install git early since it will be used later in the script
echo "Installing git..."
sudo apt install -y git

# 1. Install and start SSH server
echo "Installing and starting SSH server..."
sudo apt install -y openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Disable root password login
echo "Disabling root password login in SSH..."
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config
sudo systemctl reload ssh

# Set up SSH Public Key Authentication
echo "Enabling SSH Public Key Authentication..."
sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Determine home directory
if [ "$USER" == "root" ]; then
    SSH_DIR="/root/.ssh"
else
    SSH_DIR="/home/$USER/.ssh"
fi
AUTH_KEYS="$SSH_DIR/authorized_keys"

# Check if the public key is passed as an argument
if [ -z "$1" ]; then
  echo "Please enter your SSH public key: "
  read PUB_KEY
else
  PUB_KEY="$1"
fi

# Add the SSH public key to the authorized_keys file
echo "Adding your SSH public key..."
mkdir -p "$SSH_DIR"
chmod 700 "$SSH_DIR"
echo "$PUB_KEY" >> "$AUTH_KEYS"
chmod 600 "$AUTH_KEYS"

# Ensure the correct ownership for the .ssh directory and authorized_keys file
sudo chown -R $USER:$USER "$SSH_DIR"

# Reload the SSH service to apply changes
sudo systemctl reload ssh

# 4. Install Zsh and set it as the default shell
echo "Installing Zsh..."
sudo apt install -y zsh
echo "Changing default shell to Zsh for user $USER..."
chsh -s $(which zsh)

# 5. Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# 6. Check and install the necessary packages
echo "Installing necessary packages..."
sudo apt install -y git python3-dev libffi-dev gcc libssl-dev python3-venv

# 7. Install common tools like dig, netstat, ps, lshw, lsof
echo "Installing common tools like dig, netstat, ps, lshw, lsof..."
sudo apt install -y dnsutils net-tools procps lshw lsof atop

# 8. Ensure Docker is installed and running
if ! command -v docker &> /dev/null; then
    echo "Docker not found, installing Docker..."
    sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker is already installed."
    sudo systemctl start docker
fi

# Verify that Docker is running
if sudo systemctl is-active --quiet docker; then
    echo "Docker is running."
else
    echo "Docker failed to start."
fi

echo "Configuration is complete!"

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo "Adding Docker repository to Apt sources..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index
echo "Updating package index..."
sudo apt update

# Install the latest version of Docker
echo "Installing Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation and add user to the docker group
echo "Verifying Docker installation..."
sudo usermod -aG docker $USER
echo "Docker version:"
docker -v

echo "Docker installation completed. Please log out and log back in to use Docker without sudo."

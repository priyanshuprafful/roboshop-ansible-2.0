#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to print info messages
info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

# Function to print error messages
error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
    exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "This script must be run as root"
fi

info "Removing older versions of Docker if any..."
dnf remove -y docker \
              docker-client \
              docker-client-latest \
              docker-common \
              docker-latest \
              docker-latest-logrotate \
              docker-logrotate \
              docker-engine || true

info "Installing required packages..."
dnf -y install dnf-utils device-mapper-persistent-data lvm2

info "Setting up the Docker repository..."
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo

info "Installing Docker Engine..."
dnf install -y docker-ce docker-ce-cli containerd.io

info "Enabling and starting Docker service..."
systemctl enable --now docker

info "Docker installation completed."
docker --version

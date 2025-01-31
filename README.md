### nixos config 2025

## Overview

This repository contains my NixOS configuration, which is managed using Nix flakes. It includes a set of custom NixOS modules, home-manager configurations, and Nixpkgs overlays.

## Installation from Scratch

### Prerequisites

- NixOS live CD (download from [nixos.org](https://nixos.org/download.html))
- USB drive (at least 8GB)
- Internet connection
- If dual-booting with Fedora, note your Fedora ESP partition location

### Pre-installation Steps

1. **Boot from Live CD**
   - Create bootable USB using tools like `dd` or Etcher
   - Boot from the USB drive
   - Select "NixOS Live CD" from the boot menu

2. **Connect to Internet**
   ```bash
   # For WiFi
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "your_network_name"
   > set_network 0 psk "your_password"
   > enable_network 0
   > quit
   
   # Verify connection
   ping -c 3 google.com
   ```

3. **Set up SSH Keys**
   ```bash
   # Generate SSH key
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

### Installation Steps

1. **Clone this Repository**
   ```bash
   nix-shell -p git
   git clone https://github.com/Ogglord/nixos-config.git
   cd nixos-config
   ```

2. **Disk Partitioning**
   - This configuration uses disko for automated disk partitioning
   - Review and adjust disk configuration in `system/disk-configuration.nix`
   - The default setup includes:
     - ESP partition (128MB)
     - Root partition (BTRFS with subvolumes)
       - /rootfs → /
       - /home (with compression)
       - /nix (with compression and noatime)
   ```bash
   # Replace device path with your target disk
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./system/disk-configuration.nix
   ```

3. **Initial System Configuration**
   ```bash
   # Generate initial hardware configuration
   sudo nixos-generate-config --root /mnt
   
   # Copy your hardware-configuration.nix
   sudo cp /mnt/etc/nixos/hardware-configuration.nix system/
   
   # Install NixOS with flake
   sudo nixos-install --flake .#monsterdator
   ```

4. **Set up SOPS for Secrets**
   ```bash
   # After first boot, set up age keys
   ./scripts/setup_age.sh
   ```

### Post-installation

1. **First Boot**
   - Reboot into your new NixOS installation
   - Log in with your user credentials
   - The KDE Plasma desktop environment will start automatically

2. **Update System**
   ```bash
   # Update and apply system changes
   nix flake update && nix flake archive
   nh os switch
   ```

## Directory Structure

    .
    ├── hosts/              # Machine-specific configurations (missing)
    │   └── default.nix     # Shared configuration between hosts (missing)
    ├── modules/            # NixOS modules and hardware configurations
    ├── home/               # Home-manager configurations
    │   └── modules /       # Home-manager modules
    ├── overlays/           # Nixpkgs overlays
    └── flake.nix           # Main system configuration

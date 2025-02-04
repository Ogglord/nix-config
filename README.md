### NixOS config 2025

## Overview

This repository contains my NixOS configuration, which is managed using Nix flakes.

## Directory Structure

      .
      ├── nixos/                 # Host-specific configurations
      │   └── configuration.nix  # Default host configuration
      ├── modules/               # NixOS and home-manager modules
      ├── home-manager/          # Home-manager configurations
      │   └── home.nix           # Default home-manager configuration
      ├── secrets/               # Encrypted secrets
      └── flake.nix              # Main system configuration


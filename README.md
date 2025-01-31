### nixos config 2025

## Overview

This repository contains my NixOS configuration, which is managed using Nix flakes. It includes a set of custom NixOS modules, home-manager configurations, and Nixpkgs overlays.

## Getting Started

### Prerequisites
- Nix installed on your system
- Nix flakes enabled
- Git installed on your system

### Installation


### Daily Usage

Update and apply system changes:

```bash
nh os switch
```

## Directory Structure

    .
    ├── hosts/              # Machine-specific configurations
    │   └── default.nix     # Shared configuration between hosts
    ├── modules/            # Custom NixOS modules
    ├── home/               # Home-manager configurations
    │   └── programs/       # Program-specific configurations
    ├── overlays/           # Nixpkgs overlays
    └── flake.nix          # Main system configuration

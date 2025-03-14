# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    inputs.disko.nixosModules.disko
    inputs.vscode-server.nixosModules.default
    inputs.chaotic.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.nix-index
    inputs.sops-nix.nixosModules.sops
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    #inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    #inputs.nixos-hardware.nixosModules.common.pc.ssd

    # You can also split up your configuration and import pieces of it here:
    ./disk-configuration.nix
    ./graphics-configuration.nix
    ./bootloader.nix
    ./bluetooth
    ./flatpak
    ./kernel/xanmod
    ./kernel/cachyos
    ./power-mgmt
    ./steam
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      allowAliases = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";
  networking.hostName = "monsterdator";

  users.users = {
    ogge = {
      shell = pkgs.zsh;
      uid = 1000;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBepw1+OYharGgNwEMV+VLir7G1LWjkVSQa7HPNlYYgU ogge@Oscars-MacBook-Pro-2.local"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["wheel" "networkmanager" "audio" "video" "docker"];
    };
  };

  #############################
  #### System applications ####
  #############################
  # My custom modules
  kernel.xanmod.enable = true;
  steam.enable = true;
  steam.enableExtraPackages = true;
  steam.mangohud.enable = true;
  steam.mangohud.enableGlobalEnvVar = false;

  # standard applications
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/ogge/nix-config";
  };
  programs.nix-index-database.comma.enable = true;
  environment.systemPackages = with pkgs; [
    edk2-uefi-shell
    kdePackages.qtmultimedia
    distrobox
    i2c-tools
    lshw
  ];

  #############################
  #### Services & Desktop #####
  #############################
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };
  services.tailscale.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.vscode-server.enable = true;
  services.flatpak.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  virtualisation.docker.extraOptions = "--log-level=error";
  virtualisation.docker.enableOnBoot = false;
  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.flags = ["--all"];
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.enable = true;

  # KDE Plasma
  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [elisa krdp];
  environment.pathsToLink = ["/share/xdg-desktop-portal" "/share/applications"];

  ## SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    extraPackages = with pkgs.kdePackages; [qtmultimedia];

    settings = {
      Theme = {
        Current = "sddm-astronaut-theme";
        ThemeDir = "${pkgs.sddm-astronaut}/share/sddm/themes";
        FaceDir = "${pkgs.my-images}/share/my-images";
      };
      Autologin = {
        Session = "plasma.desktop";
        User = "ogge";
      };
      X11 = {KeyboardLayout = "sv-latin1";};
    };
  };

  #######################
  #### Time and date ####
  #######################
  time.timeZone = "Europe/Stockholm";

  ###########################
  #### Locale & Keyboard ####
  ###########################
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "sv-latin1";
    useXkbConfig = true; # use xkb.options in tty.
  };
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.variant = "";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  #############################
  #### Security settings #####
  ############################
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  system.stateVersion = "25.05"; # Do NOT change this value unless you know what you are doing!
}

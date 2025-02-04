{ lib, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./bootloader.nix
    ./graphics-configuration.nix
    ./disk-configuration.nix
    ./modules
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  networking.hostName = "monsterdator";
  networking.firewall.enable = lib.mkForce false;

  users.users.ogge = {
    shell = pkgs.zsh;
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable 'sudo' for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBepw1+OYharGgNwEMV+VLir7G1LWjkVSQa7HPNlYYgU ogge@Oscars-MacBook-Pro-2.local"
    ];
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
  programs.nix-index-database.comma.enable = true;
  environment.systemPackages = with pkgs; [
    edk2-uefi-shell
    kdePackages.qtmultimedia
    distrobox
  ];

  #############################
  #### Services & Desktop #####
  #############################
  services.tailscale.enable = true;
  services.openssh.enable = true;
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
  virtualisation.docker.autoPrune.flags = [ "--all" ];
  virtualisation.docker.storageDriver = "btrfs";
  virtualisation.docker.enable = true;

  # KDE Plasma
  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ elisa krdp ];
  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];

  ## SDDM
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    extraPackages = with pkgs.kdePackages; [ qtmultimedia ];

    settings = {
      Theme = {
        Current = "sddm-astronaut-theme";
        ThemeDir = "${pkgs.sddm-astronaut}/share/sddm/themes";
        FaceDir = "${pkgs.ogge-resources}/share/ogge-resources";
      };
      Autologin = {
        Session = "plasma.desktop";
        User = "ogge";
      };
      X11 = { KeyboardLayout = "sv-latin1"; };
    };
  };

  #######################
  #### Time and date ####
  #######################
  time.timeZone = "Europe/Stockholm";
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/ogge/nixos-config";
  };

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

  system.stateVersion =
    "25.05"; # Do NOT change this value unless you know what you are doing!
}

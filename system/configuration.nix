# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    -/bootloader.nix
    ./graphics-configuration.nix
    ./disk-configuration.nix
    ./modules
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # My custom modules
  kernel.xanmod.enable = true;
  steam.enable = true;
  steam.enableExtraPackages = true;
  steam.mangohud.enable = true;
  steam.mangohud.enableGlobalEnvVar = false;

  networking.hostName = "monsterdator"; # Define your hostname.
  networking.firewall.enable = lib.mkForce false;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/ogge/nixos-config";
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    #keyMap = "sv-latin1";
    useXkbConfig = true; # use xkb.options in tty.
  };

  ## KDE Plasma
  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ elisa krdp ];

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

  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];

  # Configure keymap in X11
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.variant = "";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.ogge = {
    shell = pkgs.zsh;
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBepw1+OYharGgNwEMV+VLir7G1LWjkVSQa7HPNlYYgU ogge@Oscars-MacBook-Pro-2.local"
    ];
  };

  #############################
  #### Security settings #####
  ############################
  security.sudo.wheelNeedsPassword = false;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  #############################
  #### System applications ####
  #############################

  programs.firefox.enable = true;
  programs.zsh.enable = true;
  environment.systemPackages = with pkgs; [
    edk2-uefi-shell
    kdePackages.qtmultimedia
  ];

  # List services that you want to enable:  
  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.vscode-server.enable = true;
  services.flatpak.enable = true;

  system.stateVersion =
    "25.05"; # Do NOT change this value unless you know what you are doing!
}

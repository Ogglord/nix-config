# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ lib, pkgs, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./graphics-configuration.nix
    ./disk-configuration.nix
    ./modules
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
    edk2-uefi-shell.enable = true;
    configurationLimit = 5; # Optional: limits number of configurations to keep
    extraEntries = {
      "bazzite_cl.conf" = ''
        title Bazzite Chainload
        efi /efi/edk2-uefi-shell/shell.efi
        options -nointerrupt -nomap -noversion HD1b:\EFI\fedora\shimx64.efi
      '';
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

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

  ## COSMIC
  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

  ## KDE6
  # Enable the X11 windowing system.
  services.xserver.enable = false;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "Dracula";
    #  keyboardLayout = "sv-latin1";
    settings = {
      Autologin = {
        Session = "plasma.desktop";
        User = "ogge";
      };
      X11 = { KeyboardLayout = "sv-latin1"; };
    };
  };

  environment.plasma6.excludePackages = with pkgs.kdePackages; [ elisa krdp ];

  environment.pathsToLink =
    [ "/share/xdg-desktop-portal" "/share/applications" ];
  services.vscode-server.enable = true;

  services.flatpak.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.variant = "";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  programs.zsh.enable = true;
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

  # Enable passwordless sudo for wheel group
  security.sudo.wheelNeedsPassword = false;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    [
      edk2-uefi-shell
      #(pkgs.catppuccin-sddm.override {
      #  flavor = "mocha";
      #  font = "Noto Sans";
      #  fontSize = "9";
      #  #background = "/home/ogge/Pictures/wallpapers/1.jpg";
      #  loginBackground = true;
      #})
      #nixpkgs-fmt
      #dr460nized-kde-theme # chaotic nix repo
      #proton-ge-custom
    ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?
}

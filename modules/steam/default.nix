{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.steam;
in {
  imports = [./extra-packages.nix];
  options.steam = {
    enable = mkEnableOption "Enable steam module";
  };
  config = {
    #=> Steam <=#
    programs.steam = {
      enable = cfg.enable;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      extest.enable = true; # For using Steam Input on Wayland
      #protontricks.enable = true;
      package = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            libkrb5
            stdenv.cc.cc.lib
            keyutils
          ];
      };
    };
    #= Enable/Disable Steam Hardware Udev Rules
    hardware.steam-hardware.enable = lib.mkDefault false;

    environment.systemPackages = with pkgs; [
      adwsteamgtk
    ];

    #=> Gamescope <=#
    programs.gamescope = {
      enable = cfg.enable;
      package = pkgs.gamescope;
      capSysNice = true;
    };
  };
}

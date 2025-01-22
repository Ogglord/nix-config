{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.programs.steam;
in {
  options.steam = {
    enableExtraPackages = lib.mkEnableOption "steam extra packages";
  };

  config = lib.mkIf cfg.enableExtraPackages {
    environment.systemPackages = with pkgs; [
      winetricks
      protontricks
      protonup-qt
      proton-ge-custom
      mangohud_git
    ];
  };
}

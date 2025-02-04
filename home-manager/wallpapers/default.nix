{ config, lib, ... }:
with lib;
let cfg = config.wallpaper;
in {
  options = {
    wallpaper.enable = mkEnableOption "Enable wallpaper";

  };
  config = mkIf cfg.enable {
    home.file = { "Pictures/wallpapers".source = ./wallpapers; };
    programs.plasma.workspace.wallpaper =
      mkForce "${config.home.homeDirectory}/Pictures/wallpapers/1.jpg";
  };
}

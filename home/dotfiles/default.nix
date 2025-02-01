{ config, lib, ... }:
with lib;
let cfg = config.wallpaper;
in {
  options = {
    dotfiles = mkOption {
      type = types.path;
      apply = toString;
      default =
        "${config.home.homeDirectory}/nixos-config/home-manager/dotfiles";
      example =
        "${config.home.homeDirectory}/nixos-config/home-manager/dotfiles";
      description = "Location of the dotfiles working copy";
    };
    wallpaper.enable = mkEnableOption "Enable wallpaper";

  };
  config = mkIf cfg.enable {
    home.file = { "Pictures/wallpapers".source = ./wallpapers; };
    programs.plasma.workspace.wallpaper =
      mkForce "${config.home.homeDirectory}/Pictures/wallpapers/1.jpg";
  };
}

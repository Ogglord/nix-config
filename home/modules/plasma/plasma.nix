{ config, lib, pkgs, ... }:
with lib;
let cfg = config.plasma;
in {
  options.plasma = { enable = mkEnableOption "plasma"; };

  config = mkIf cfg.enable {

    home.packages = with pkgs; [
      # Themes and Customization
      bibata-cursors
      papirus-nord
      dracula-icon-theme
      dracula-theme
    ];

    programs.plasma = {
      enable = true;

      workspace = {
        clickItemTo = "select";
        iconTheme = "Dracula";
        theme = "Dracula";
        colorScheme = "Dracula";
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 32;
        };
        wallpaper =
          "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images_dark/3840x2160.png";
      };

      shortcuts = {
        "kwin"."Switch to Desktop 1" = "Meta+1";
        "kwin"."Switch to Desktop 2" = "Meta+2";
        "kwin"."Switch to Desktop 3" = "Meta+3";
        "kwin"."Switch to Desktop 4" = "Meta+4";
      };

      panels = [{
        location = "bottom";
        height = 38;
      }];

      input.keyboard = {
        numlockOnStartup = "on";
        layouts = [{ layout = "sv"; }];
        options = [ "eurosign:e" "caps:escape" ];
      };
    };
  };
}

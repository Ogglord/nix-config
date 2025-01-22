{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.steam.mangohud;
in {
  options.steam.mangohud = {
    enable = lib.mkEnableOption "install mangohud";
    enableGlobalEnvVar = lib.mkEnableOption "enable mangohud using global env variable";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      mangohud
      mangojuice
    ];
    environment.variables = lib.mkIf cfg.enableGlobalEnvVar {
      MANGOHUD = "1";
    };
  };
}

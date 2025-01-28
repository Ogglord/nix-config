{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.macchina;
  # Import the configuration at the top level
  macchinaConfig = import ./macchina.nix {inherit config lib pkgs;};
in {
  options.macchina = {
    enable = mkEnableOption "Enable macchina module";
  };

  config = mkIf cfg.enable macchinaConfig;
}

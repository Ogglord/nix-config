{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.zed;
  # Import the configuration at the top level
  zedConfig = import ./zed.nix { inherit config lib pkgs; };
in {
  options.zed = {
    enable = mkEnableOption "Enable zed module";
  };

  config = mkIf cfg.enable zedConfig;
}

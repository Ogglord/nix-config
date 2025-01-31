{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.zed;
  # Import the configuration at the top level
  zshConfig = import ./zsh.nix { inherit config lib pkgs; };
in {
  options.zsh = {
    enable = mkEnableOption "Enable zsh module";
  };

  config = mkIf cfg.enable zshConfig;
}

{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vscode;
  # Import the configuration at the top level
  vscodeConfig = import ./vscode.nix {inherit config lib pkgs;};
in {
  options.vscode = {
    enable = mkEnableOption "Enable vscode module";
  };

  config = mkIf cfg.enable vscodeConfig;
}

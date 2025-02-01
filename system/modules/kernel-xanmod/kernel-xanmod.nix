{ lib, pkgs, config, ... }:
with lib;
let cfg = config.kernel.xanmod;
in {
  options.kernel.xanmod = { enable = mkEnableOption "xanmod"; };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_xanmod_latest;
    hardware.xone.enable = true;
    environment.systemPackages = with pkgs;
      [ linuxKernel.packages.linux_xanmod_latest.xone ];
  };
}

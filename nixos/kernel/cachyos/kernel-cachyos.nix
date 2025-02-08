{ lib, pkgs, config, ... }:
with lib;
let cfg = config.kernel.cachyos;
in {
  options.kernel.cachyos = { enable = mkEnableOption "cachyos"; };

  config = mkIf cfg.enable {
    boot.kernelPackages = pkgs.linuxPackages_cachyos;

    # scheduler
    services.scx.enable = true; # by default uses scx_rustland scheduler
    #services.scx.package = pkgs.scx_git.full; # latest from git
    services.scx.scheduler = "scx_lavd";
    services.scx.extraArgs = [ "--performance" ];

    # boot.kernelParams = ["cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes"];
    # boot.kernel.sysctl = {
    #   "vm.swappiness" = 90; # when swapping to ssd, otherwise change to 1
    #   "vm.vfs_cache_pressure" = 50;
    #   "vm.dirty_background_ratio" = 20;
    #   "vm.dirty_ratio" = 50;
    #   # these are the zen-kernel tweaks to CFS defaults (mostly)
    #   "kernel.sched_latency_ns" = 4000000;
    #   # should be one-eighth of sched_latency (this ratio is not
    #   # configurable, apparently -- so while zen changes that to
    #   # one-tenth, we cannot):
    #   "kernel.sched_min_granularity_ns" = 500000;
    #   "kernel.sched_wakeup_granularity_ns" = 50000;
    #   "kernel.sched_migration_cost_ns" = 250000;
    #   "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    #   "kernel.sched_nr_migrate" = 128;
    # };
  };
}

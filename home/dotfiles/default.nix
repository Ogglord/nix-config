{ config, lib, ... }:
{
  options = {
    dotfiles = lib.mkOption {
      type = lib.types.path;
      apply = toString;
      default = "${config.home.homeDirectory}/nixos-config/home-manager/dotfiles";
      example = "${config.home.homeDirectory}/nixos-config/home-manager/dotfiles";
      description = "Location of the dotfiles working copy";
    };
  };
}

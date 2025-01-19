{ pkgs, lib, config, ... }:
{
  home.packages = with pkgs;[
    zsh
  ];

  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${config.dotfiles}/zshrc";



}

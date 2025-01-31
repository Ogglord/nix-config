{
  pkgs,
  lib,
  config,
  ...
}: {
  home.packages = with pkgs; [
    macchina # neofetch alternative in rust
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/macchina/themes/birdie.toml".source = ./macchina_birdie.toml;
    ".config/macchina/themes/birdie.ascii".source = ./macchina_birdie.ascii;
    ".config/macchina/macchina.toml".source = ./macchina.toml;
  };
}

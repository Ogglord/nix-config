# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default
    inputs.sops-nix.homeManagerModules.sops
    inputs.nix-colors.homeManagerModules.default
    inputs.plasma-manager.homeManagerModules.plasma-manager
    #{
    #  nixpkgs.config.allowUnfree = true;
    #  nixpkgs.config.allowAliases = true;
    #}

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./zsh
    ./zed
    ./macchina
    ./plasma
    ./vscode
    ./wallpapers
  ];

  home = {
    username = "ogge";
    homeDirectory = "/home/ogge";
  };

  colorScheme = inputs.nix-colors.colorSchemes.nord;

  ## my custom options
  zed.enable = true;
  zsh.enable = true;
  macchina.enable = true;
  vscode.enable = true;
  plasma.enable = true;
  wallpaper.enable = true;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    #alejandra # nix formatter written in rust
    btop
    direnv
    fio
    ghostty
    iperf3
    ncdu
    nil
    #nixd
    #nixfmt
    nordic

    # Fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.code-new-roman
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # Development Tools
  # ------------------------

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Ogglord";
    userEmail = "oag@proton.me";
    extraConfig = { init.defaultBranch = "main"; };
  };

  # GitHub CLI Configuration
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
  };

  # Sops configuration
  sops = {
    age.keyFile = "/home/ogge/.config/sops/age/keys.txt";
    defaultSopsFile = ./../secrets/secrets.yaml;
    secrets.ANTHROPIC_API_KEY = {
      path = "%r/ANTHROPIC_API_KEY"; # %r becomes /run/user/1000/
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}

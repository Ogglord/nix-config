{ pkgs, ... }:
let USER = "ogge";
in {
  imports = [ ./dotfiles ./modules ];
  ## my modules goes here
  zed.enable = true;
  zsh.enable = true;
  macchina.enable = true;
  vscode.enable = true;
  plasma.enable = true;
  wallpaper.enable = true;

  # ------------------------
  # User Configuration
  # ------------------------
  home = {
    username = "${USER}";
    homeDirectory = "/home/${USER}";
    stateVersion = "23.11"; # Do not change unless you know what you're doing
    file.".face".source =
      "${pkgs.ogge-resources}/share/ogge-resources/ogge.jpeg";

    # Environment Variables
    sessionVariables = {
      EDITOR = "nano";
      #COSMIC_DATA_CONTROL_ENABLED = 1;
    };

    # User Packages
    packages = with pkgs; [
      # System Utilities
      alejandra # nix formatter written in rust
      btop
      comma # run any app without installing, prefix it with ","
      ghostty
      direnv
      nil
      nixd
      nixfmt
      nordic

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.code-new-roman
    ];
  };

  # System Configuration
  # ------------------------
  #fonts.fontconfig.enable = true;
  programs.home-manager.enable = false;

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
    #GitCredentialHelper.enable = true;
  };

  # Sops configuration
  sops = {
    age.keyFile = "/home/ogge/.config/sops/age/keys.txt";
    defaultSopsFile = ./../secrets/secrets.yaml;
    secrets.ANTHROPIC_API_KEY = {
      path = "%r/ANTHROPIC_API_KEY"; # %r becomes /run/user/1000/
    };
  };
}


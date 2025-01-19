{ config, pkgs, sops-nix, ... }:

let 
  USER = "ogge";
  UID = 1000;
in 
{
  imports = [
    ./modules/zed
  ];

  # User Configuration
  # ------------------------
  home = {
    username = "ogge";
    homeDirectory = "/home/ogge";
    stateVersion = "23.11"; # Do not change unless you know what you're doing

    # Environment Variables
    sessionVariables = {
      EDITOR = "nano";      
    };

    # User Packages
    packages = with pkgs; [
      # System Utilities
      btop

      # Themes and Customization
      bibata-cursors
      papirus-nord
      nil
      nordic

      # Fonts
      nerd-fonts.jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.code-new-roman
    ];
  };

  # System Configuration
  # ------------------------
  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;

  # Development Tools
  # ------------------------

  # Git Configuration
  programs.git = {
    enable = true;
    userName = "Ogglord";
    userEmail = "oag@proton.me";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  # GitHub CLI Configuration
  programs.gh = {
    enable = true;
    settings.git_protocol = "https";
    #GitCredentialHelper.enable = true;
  };

  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    extensions = [
      { id = "ghmbeldphafepmbegfdlkpapadhbakde";} #protonpass
    ];
  };

  # VSCode Configuration
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    extensions = (with pkgs.vscode-extensions; [
      # Development Tools
      ms-vscode-remote.remote-ssh
      mhutchie.git-graph
      jnoortheen.nix-ide

      # UI Enhancements
      pkief.material-icon-theme

      # AI Assistance
      saoudrizwan.claude-dev
    ]);
  };

  # Terminal Configuration
  # ------------------------
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        normal.style = "Regular";
        bold.family = "JetBrainsMono Nerd Font";
        bold.style = "Bold";
        italic.family = "JetBrainsMono Nerd Font";
        italic.style = "Italic";
        bold_italic.family = "JetBrainsMono Nerd Font";
        bold_italic.style = "Bold Italic";
        size = 10.0;
      };
    };
  };

  # Desktop Environment Configuration
  # ------------------------
  programs.plasma = {
    enable = true;

    # Workspace Theme and Appearance
    workspace = {
      clickItemTo = "select";
      iconTheme = "Papirus-Dark";
      theme = "Nordic";
      colorScheme = "Nordic";
      cursor = {
        theme = "Bibata-Modern-Ice";
        size = 32;
      };
      wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Patak/contents/images_dark/3840x2160.png";
    };

    # Keyboard Shortcuts
    shortcuts = {
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
    };

    # Panel Configuration
    panels = [{
      location = "bottom";
      height = 38;
    }];

    # Input Settings
    input.keyboard = {
      numlockOnStartup = "on";
      layouts = [{ layout = "sv"; }];
      options = [
        "eurosign:e"
        "caps:escape"
      ];
    };
  };

  # Application Entries
  # ------------------------
  xdg.desktopEntries.zed = {
    name = "Zed";
    comment = "A high-performance, multiplayer code editor";
    exec = "zeditorw %F";
    icon = "zed";
    categories = [ "Development" "TextEditor" ];
    terminal = false;
    type = "Application";
  };

   # Sops configuration
  sops = {
    age.keyFile = "/home/ogge/.config/sops/age/keys.txt";
    defaultSopsFile = ./../secrets/secrets.yaml;
    secrets.ANTHROPIC_API_KEY = {
      path = "%r/ANTHROPIC_API_KEY"; #%r becomes /run/user/1000/
    };
  };
}

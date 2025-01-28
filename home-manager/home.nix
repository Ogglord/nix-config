{
  config,
  pkgs,
  sops-nix,
  ...
}: let
  USER = "ogge";
  UID = 1000;
  cody-ai = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "cody-ai";
      publisher = "sourcegraph";
      version = "1.62.1"; # Replace with the current version
      sha256 = "sha256-t8m6+L1Y6Fi6cIUVy0F99atFOWpX6tuXJ0xxnUgwmfk=";
    };
  };
in {
  imports = [
    ./dotfiles
    ./modules/zed
    ./modules/zsh
    ./modules/macchina
  ];
  ## my modules goes here
  zed.enable = true;
  zsh.enable = true;
  macchina.enable = true;

  # ------------------------
  # User Configuration
  # ------------------------
  home = {
    username = "ogge";
    homeDirectory = "/home/ogge";
    stateVersion = "23.11"; # Do not change unless you know what you're doing

    # Environment Variables
    sessionVariables = {
      EDITOR = "nano";
      #COSMIC_DATA_CONTROL_ENABLED = 1;
    };

    # User Packages
    packages = with pkgs; [
      # System Utilities
      alejandra #nix formatter written in rust
      btop
      comma # run any app without installing, prefix it with ","
      ghostty
      direnv
      # Themes and Customization
      bibata-cursors
      papirus-nord
      nil
      nixd
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
  programs.home-manager.enable = false;

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

  # VSCode Configuration
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = {
      "extensions.autoCheckUpdates" = false;
      "update.mode" = "none";
      "editor.inlineSuggest.suppressSuggestions" = true;
      "git.enableSmartCommit" = true;
      "git.confirmSync" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
          "options" = {
            "nixos" = {
              "expr" = "(builtins.getFlake \"/home/ogge/nixos-config/flake.nix\").nixosConfigurations.monsterdator.options";
            };
          };
        };
      };
    };

    extensions = with pkgs.vscode-extensions;
      [
        # Development Tools
        ms-vscode-remote.remote-ssh
        mhutchie.git-graph
        jnoortheen.nix-ide

        # UI Enhancements
        pkief.material-icon-theme

        # AI Assistance
        saoudrizwan.claude-dev

        # straight_from_marketplace
      ]
      ++ [cody-ai];
  };

  # Desktop Environment Configuration
  # ------------------------
  programs.plasma = {
    enable = false;

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
    panels = [
      {
        location = "bottom";
        height = 38;
      }
    ];

    # Input Settings
    input.keyboard = {
      numlockOnStartup = "on";
      layouts = [{layout = "sv";}];
      options = [
        "eurosign:e"
        "caps:escape"
      ];
    };
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

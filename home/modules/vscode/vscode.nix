{ config, pkgs, ... }:
let
  cody-ai = pkgs.vscode-utils.buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "cody-ai";
      publisher = "sourcegraph";
      version = "1.62.1"; # Replace with the current version
      sha256 = "sha256-t8m6+L1Y6Fi6cIUVy0F99atFOWpX6tuXJ0xxnUgwmfk=";
    };
  };
in {
  # VSCode Configuration
  programs.vscode = {
    enable = true;
    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;
    mutableExtensionsDir = false;

    userSettings = {
      "terminal.integrated.fontFamily" = "Iosevka Nerd Font Propo";
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
            #"command" = ["alejandra"];
            "command" = [ "nixfmt" ];
          };
          #"options" = {
          #  "nixos" = {
          #    "expr" = "(builtins.getFlake \"/home/ogge/nixos-config/flake.nix\").nixosConfigurations.monsterdator.options";
          #  };
          #};
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
        github.copilot
        github.copilot-chat

        # straight_from_marketplace
      ] ++ [ cody-ai ];
  };
}

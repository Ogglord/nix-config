{pkgs, ...}: let
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
      "git.postCommitCommand" = "sync";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "cody.suggestions.mode" = "auto-edit (Experimental)";
      "nix.enableLanguageServer" = true;
      #"nix.serverPath" = "nil";
      #"nix.serverSettings" = {
      #  "nil" = {
      #    "diagnostics" = {"ignored" = ["unused_binding" "unused_with"];};
      #    "formatting" = {"command" = ["alejandra"];};
      #  };
      #};
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "diagnostics" = {"ignored" = ["unused_binding" "unused_with"];};
          "formatting" = {"command" = ["alejandra"];};
        };
      };
      "nix.hiddenLanguageServerErrors" = [
        "textDocument/formatting"
        "textDocument/definition"
      ];
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
      ]
      ++ [cody-ai];

    ## test comment
  };
}

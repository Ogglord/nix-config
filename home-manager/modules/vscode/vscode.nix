{
  config,
  pkgs,
  ...
}: {
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
}

{...}: let
  # Yellow color code
  yellow = "\\033[33m";
  reset = "\\033[0m";

  # Get all immediate subdirectories
  subdirs =
    builtins.trace "Importing home-manager modules: ${yellow}${toString (builtins.filter (x: x != "default.nix") (builtins.attrNames (builtins.readDir ./.)))}${reset}"
    (builtins.attrNames (builtins.readDir ./.));

  # Filter out regular .nix files
  moduleDirs =
    builtins.filter (
      name:
        name
        != "default.nix"
        && (builtins.pathExists (./. + "/${name}/default.nix")
          || builtins.match ".*\\.nix" name != null)
    )
    subdirs;

  # Create import paths
  imports = map (name: ./. + "/${name}") moduleDirs;
in {
  imports = imports;
}

{...}: let
  # Get all immediate subdirectories
  subdirs =
    builtins.trace "Importing home-manager modules: ${toString (builtins.filter (x: x != "default.nix") (builtins.attrNames (builtins.readDir ./.)))}"
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

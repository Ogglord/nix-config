{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, flake-utils, pre-commit-hooks, ... }@inputs:
    let
      system = "x86_64-linux";

      myPackages = final: prev: {
        ogge-resources = final.callPackage ./pkgs/ogge-resources { };
      };
    in {
      checks.${system} = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true; # Nix formatter
            nixpkgs-fmt.enable = true;
            statix.enable = true; # Nix linter
            deadnix.enable = true; # Find dead Nix code
          };
        };
      };

      nixosConfigurations = {
        # Using the hostname from configuration.nix
        monsterdator = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            { nixpkgs.overlays = [ myPackages ]; }
            {
              nix.settings = {
                substituters = [ "https://cosmic.cachix.org/" ];
                trusted-public-keys = [
                  "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
                ];
              };
            }
            ./system/configuration.nix

            inputs.disko.nixosModules.disko
            inputs.vscode-server.nixosModules.default
            inputs.chaotic.nixosModules.default
            inputs.nix-flatpak.nixosModules.nix-flatpak
            inputs.nix-index-database.nixosModules.nix-index
            inputs.sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "bak";
              home-manager.sharedModules =
                [ inputs.sops-nix.homeManagerModules.sops ];
              home-manager.users.ogge = { ... }: {
                imports = [
                  ./home/home.nix
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                  {
                    nixpkgs.config.allowUnfree = true;
                    nixpkgs.config.allowAliases = true;
                  }
                ];
              };
            }
          ];
        };
      };
    };
}

{
  description = "NixOS configuration";

  inputs = {
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

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

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      myPackages = final: prev: {
        ogge-resources = final.callPackage ./pkgs/ogge-resources { };
      };
    in {
      nixosConfigurations = {
        # Using the hostname from configuration.nix
        monsterdator = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
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

      devShells.${system}.openwrt = pkgs.mkShell {
        name = "openwrt-devshell";
        buildInputs = with pkgs; [
          bison
          gnupg
          go
          libelf
          llvmPackages_latest.llvm
          ncdu
          openssl
          swig
          quilt
          squashfsTools
          unzip
          wget
          zstd
          ncurses
          pkg-config
          (python3.withPackages (ps: [ ps.distutils ps.pip ps.setuptools ]))
        ];
        shellHook = ''
          # Find the most recent LLVM library path
          LLVM_HOST_PATH=${pkgs.llvmPackages_latest.llvm}/bin

          # Export the LLVM host path
          export LLVM_HOST_PATH

          echo "OpenWrt development shell"
          echo "LLVM Host Path: $LLVM_HOST_PATH"
          echo "ncurses-dev Path: ${pkgs.ncurses.dev}"
        '';
      };
    };
}

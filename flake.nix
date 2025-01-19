{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    
    nix-environments = {
      url = "github:nix-community/nix-environments";
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

  outputs = {
    self,
    nixpkgs,
    disko,
    home-manager,
    plasma-manager,
    nix-environments,
    ...
  } @ inputs: {
    devShells.x86_64-linux.openwrt = 
      let 
        pkgs = nixpkgs.packages.x86_64-linux;
      in (import nix-environments.packages.x86_64-linux.openwrt) {
        inherit pkgs;
        extraPkgs = [pkgs.llvmPackages_latest.llvm];
      };

    nixosConfigurations = {
      # Using the hostname from configuration.nix
      monsterdator = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          inputs.vscode-server.nixosModules.default
          inputs.chaotic.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "bak";
            home-manager.sharedModules = [
              inputs.sops-nix.homeManagerModules.sops
            ];
            home-manager.users.ogge = {pkgs, ...}: {
              imports = [
                ./home-manager/home.nix
                plasma-manager.homeManagerModules.plasma-manager
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

    homeConfigurations = {
      ogge = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home-manager/home.nix
          plasma-manager.homeManagerModules.plasma-manager
          {
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.allowAliases = true;
          }
        ];
      };
    };
  };
}

{
  description = "Starscream NixOS setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    arion = {
      url = "github:hercules-ci/arion";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs =
    inputs@{
      arion,
      nixpkgs,
      home-manager,
      plasma-manager,
      sops-nix,
      ...
    }:
    {
      nixosConfigurations = {
        starscream = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./nixos/configuration.nix
            arion.nixosModules.arion
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.marcelo = import ./marcelo/home.nix;
                extraSpecialArgs = {
                  inherit inputs;
                };
                sharedModules = [
                  plasma-manager.homeModules.plasma-manager
                  sops-nix.homeManagerModules.sops
                ];
              };
            }
          ];
        };
      };
    };
}

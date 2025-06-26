{
  description = "NixOS 25.05 Warbler configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    compose2nix = {
        url = "github:aksiksi/compose2nix";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let system = "x86_64-linux"; in {
      nixosConfigurations.microserver = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./modules/hardware.nix
          ./modules/networking.nix
          ./modules/users.nix
          ./modules/docker.nix
          ./modules/hassos.nix
          ./hosts/microserver.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.irave = import ./home/default.nix;
          }
        ];
      };
    };
}

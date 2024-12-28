{
  description = "Nixos config flake";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      ... 
    }@inputs:

    let
      hosts = import ./config/hosts.nix;

      mkNixOSConfigurations = 
        {
          host,
          nixpkgs,
          home-manager,
          modules ? []
        }:
        nixpkgs.lib.nixosSystem {
          system = host.arch;
          modules = [
            .hosts/${host.dir}/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.users."${host.user}" = import ./hosts/${host.dir}/home.nix;
            }
          ] ++ modules;
        };
    in
    {
      nixosConfigurations."${hosts.work.hostname}" = mkNixOSConfigurations {
        host = hosts.work;
        nixpkgs = inputs.nixpkgs;
        home-manager = inputs.home-manager;
      };
    };
}


{
  description = "Nix, Nixos and flake configuraiton";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User enviroment manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:Hexamo/nixvim-config2/main";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }:
     let
       vars = {
         # User Configuration
         username = "mads";
         terminal = "kitty";
         wallpaper = "default";
         editor = "nvim";

         # System Configuraiton
         hostname = "ceris";
         locale = "en_DK.UTF-8";
         extraLocale = "da_DK.UTF-8";
         timezone = "Europe/Copenhagen";
         kbdLayout = "dk";
         consoleKbdKeymap = "dk-latin1";
         system = "x86_64-linux";

       };
       system = "x86_64-linux";
       lib = nixpkgs.lib;
     in
  {
    nixosConfigurations = {
      ceris = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs vars; };
        modules = [
          ./hosts/configuration.nix
          ./hosts/ceris
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs vars; };
            home-manager.users.${vars.username} = import ./hosts/ceris/home.nix;
          }
        ];
      };
    };  
  };
}

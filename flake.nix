{
  description = "Nix, Nixos and flake configuraiton";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User enviroment manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim-config.url = "github:Hexamo/nixvim-config2/main";
    nixvim-config.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    nixpkgs-unstable,
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

      # Specifies system version.
      # TODO: Find a better way to handle this
      system = "x86_64-linux";

      # lessens some boilerplate writing
      lib = nixpkgs.lib;

      # enables us to use unstable packages in our system
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
     in
  {
    nixosConfigurations = {
      ceris = lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs vars pkgs-unstable; };
        modules = [

          # Enables nix-vscode-extensions overlay that allows us to 
          # install vscode extensions from other locations
          {
            nixpkgs.overlays = [
              inputs.nix-vscode-extensions.overlays.default
            ];
          }

          # Imports configuration and the host defaults
          ./hosts/configuration.nix
          ./hosts/ceris

          # Imports home-manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs vars pkgs-unstable; };
            home-manager.users.${vars.username} = import ./hosts/ceris/home.nix;
          }
        ];
      };
    };  
  };
}

{
  description = "Nix, Nixos and flake configuraiton";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User enviroment manager
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs-unstable";

    #hyprland.url = "github:hyprwm/Hyprland";
    #hyprland.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      ...
    }:
    let
      systemVars = {
        system = "x86_64-linux";
        hostname = "ceris";
        hosts = "work";
        timezone = "Europe/Copenhagen";
        locale = "en_DK.UTF-8";
        extraLocale = "da_DK.UTF-8";
        kbdLayout = "dk";
        consoleKbdKeymap = "dk-latin1";
      };
      userVars = {
        userName = "mads";
        name = "Mads";
        fullName = "Mads Kristiansen";
        emial = "mads@skumnet.dk";
        dotfilesDir = "~/.dotfiles";
        wm = "river";
        browser = "firefox";
        term = "kitty";
        font = "IosevkaTerm Nerd Font Mono";
        editor = "nvim";
      };
      vars = {
        # User Configuration
        username = "mads";
        terminal = "kitty";
        wallpaper = "default";
        editor = "nvim";
        fullname = "Mads Kristiansen";

        # System Configuraiton
        hostname = "ceris";
        locale = "en_DK.UTF-8";
        extraLocale = "da_DK.UTF-8";
        timezone = "Europe/Copenhagen";
        kbdLayout = "us";
        consoleKbdKeymap = "us";
        system = "x86_64-linux";
      };

      # lessens some boilerplate writing
      lib = nixpkgs.lib;

      # enables us to use unstable packages in our system
      pkgs-unstable = import nixpkgs-unstable {
        system = vars.system;
        config.allowUnfree = true;
      };
      pkgs = nixpkgs.legacyPackages.${vars.system};
    in
    {
      homeConfigurations = {
        user = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            {
              nixpkgs.overlays = [
                inputs.nix-vscode-extensions.overlays.default
              ];
            }
            ./hosts/ceris/home.nix
          ];
          extraSpecialArgs = {
            inherit vars;
            inherit inputs;
            inherit pkgs-unstable;
          };
        };
      };
      nixosConfigurations = {
        system = lib.nixosSystem {
          system = vars.system;
          specialArgs = {
            inherit inputs;
            inherit vars;
            inherit userVars;
            inherit pkgs-unstable;
          };
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

          ];
        };
      };
    };
}

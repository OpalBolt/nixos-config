{
  description = "Nix, Nixos and flake configuration";

  inputs = {
    # Core nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Extension and package sources
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Neovim configurations
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    nixCats-test.url = "git+https://codeberg.org/OpalBolt/nixcats-test?ref=main";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/OpalBolt/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
    hardware = {
      url = "github:nixos/nixos-hardware";
    };

    # Desktop environments (currently disabled)
    #hyprland = {
    #  url = "github:hyprwm/Hyprland";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      sops-nix,
      ...
    }:
    let
      # --- Library Setup ---
      # Import custom lib and extend nixpkgs lib
      customLib = import ./lib { inherit (nixpkgs) lib; };
      varsLib = import ./lib/vars { lib = nixpkgs.lib; pkgs = nixpkgs.legacyPackages.${defaultSystem}; };
      lib = nixpkgs.lib.extend (final: prev: { 
        custom = customLib; 
        vars = varsLib;
      });

      # --- Package Sets ---
      # Function to create standard package set for a system
      forSystem = system: nixpkgs.legacyPackages.${system};

      # Standard packages for current system
      pkgs = forSystem currentSystem;

      # Unstable packages accessor function
      pkgs-unstable =
        system:
        import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

      # --- System Architecture Handling ---
      # Default system architecture
      defaultSystem = "x86_64-linux";

      # Detect current system architecture or fall back to default
      currentSystem = builtins.currentSystem or defaultSystem;

      # Function to get system from host config or use default
      getHostSystem =
        hostname:
        let
          hostPath = ./hosts + "/${hostname}";
          hostExists = builtins.pathExists hostPath;

          hostConfig =
            if hostExists && builtins.pathExists (hostPath + "/default.nix") then
              import (hostPath + "/default.nix") {
                vars = {
                  system = defaultSystem;
                };
                pkgs = pkgs;
                pkgs-unstable = pkgs-unstable;
                # Pass the extended library to the host configuration
                lib = lib;
                # Pass inputs to the host configuration
                inherit inputs;
                # Pass a minimal config to prevent the "required argument 'config'" error
                config = {
                  # Provide default values for systemVars and userVars that are accessed in the host config
                  systemVars = { 
                    system = defaultSystem;
                    hostname = hostname; 
                  };
                  userVars = { };
                };
              }
            else
              { };

          system =
            if hostConfig ? systemVars && hostConfig.systemVars ? system then
              hostConfig.systemVars.system
            else
              defaultSystem;
        in
        system;

      

      # --- NixOS Configuration Generation ---
      # Function to dynamically create NixOS configurations for a host
      mkHost =
        hostname:
        let
          # Get the system architecture for this host
          system = getHostSystem hostname;

          # Create package sets for this system
          pkgsUnstableForSystem = pkgs-unstable system;
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname;
            pkgs-unstable = pkgsUnstableForSystem;
            # Pass our extended lib to all modules
            lib = lib;
          };
          modules = [
            # Add overlays
            {
              nixpkgs.overlays = [
                inputs.nix-vscode-extensions.overlays.default
              ];
              nixpkgs.config.allowUnfree = true;
            }

            # Import configuration
            ./hosts/configuration.nix
            (./hosts + "/${hostname}")
          ];
        };

      # --- Dynamic Host Configuration Discovery ---
      # Get all host directories with a default.nix file
      hostNames = builtins.filter (name: builtins.pathExists (./hosts + "/${name}/default.nix")) (
        builtins.attrNames (builtins.readDir ./hosts)
      );
    in
    {

      # Generate configurations for all discovered hosts
      nixosConfigurations = builtins.listToAttrs (
        map (hostname: {
          name = hostname;
          value = mkHost hostname;
        }) hostNames
      );
    };
}

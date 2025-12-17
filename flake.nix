{
  description = "Nix, Nixos and flake configuration";

  inputs = {
    # Core nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
    neovim-config-nix.url = "git+https://codeberg.org/OpalBolt/neovim-config-nix?ref=main";
    neovim-config-nix.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/OpalBolt/nix-secrets.git?ref=main&shallow=1";
    };
    hardware.url = "github:nixos/nixos-hardware";

    # Declarative vms using libvirt
    nixvirt = {
      url = "https://flakehub.com/f/AshleyYakeley/NixVirt/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    time-helper = {
      url = "git+https://codeberg.org/OpalBolt/time-helper?ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qbpm = {
      url = "github:pvsr/qbpm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      sops-nix,
      neovim-config-nix,
      time-helper,
      ...
    }@inputs:
    let
      # --- Library Setup ---
      # Import custom lib and extend nixpkgs lib
      lib = nixpkgs.lib.extend (
        final: prev: {
          custom = import ./lib { inherit (nixpkgs) lib; };
        }
      );

      # Helper function for systems
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      # --- Overlays ---
      overlays = import ./overlays { inherit inputs; };

      # --- Host Configurations ---
      # Simple host discovery by reading directories in hosts/
      nixosConfigurations = builtins.listToAttrs (
        map
          (hostname: {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit inputs hostname lib;
                # Access unstable packages through pkgs.unstable
              };
              modules = [
                # Global overlay and config
                {
                  nixpkgs.overlays = [
                    self.overlays.default
                    inputs.nix-vscode-extensions.overlays.default
                  ];
                  nixpkgs.config.allowUnfree = true;
                  system.nixos.revision =
                    self.rev or (
                      if self ? "dirtyRev" then
                        "${self.dirtyRev}-${self.lastModifiedDate}"
                      else
                        "dirty-${self.lastModifiedDate}"
                    );

                }
                inputs.solaar.nixosModules.default
                inputs.determinate.nixosModules.default

                # Import configurations
                (./hosts/nixos + "/${hostname}")
              ];
            };
          })
          (
            # Get all host directories with a default.nix file
            builtins.filter (name: builtins.pathExists (./hosts/nixos + "/${name}/default.nix")) (
              builtins.attrNames (builtins.readDir ./hosts/nixos)
            )
          )
      );

      # --- Formatter ---
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      # --- DevShell ---
      # Useful for development, accessible via `nix develop`
      devShells = forAllSystems (system: {
        default = import ./shell.nix {
          pkgs = nixpkgs.legacyPackages.${system};
        };
      });
    };
}

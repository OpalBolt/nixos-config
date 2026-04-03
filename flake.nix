{
  description = "Nix, NixOS and flake configuration — den aspect-oriented format";

  inputs = {
    # Core nixpkgs channels
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # User environment management
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Den — aspect-oriented NixOS framework
    den.url = "github:vic/den";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    # Extension and package sources
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    secure-handling-of-secrets = {
      url = "git+ssh://git@github.com/eficode/secure-handling-of-secrets?ref=feat/sleep-lock-cleanup";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-secrets = {
      url = "git+ssh://git@github.com/OpalBolt/nix-secrets.git?ref=main&shallow=1";
    };

    # Hardware modules
    hardware.url = "github:nixos/nixos-hardware";

    # Extra tooling
    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    time-helper = {
      url = "github:OpalBolt/Time-Helper";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qbpm = {
      url = "github:pvsr/qbpm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  # All configuration lives in modules/ — loaded via import-tree.
  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}

# Miscellaneous flake outputs: formatter, devShells, overlays export.
{ inputs, ... }:
{
  systems = [ "x86_64-linux" ];

  perSystem =
    { system, ... }:
    {
      formatter = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
      devShells.default = import ../shell.nix {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    };

  # Re-export overlays for downstream consumers
  flake.overlays = import ../overlays { inherit inputs; };
}

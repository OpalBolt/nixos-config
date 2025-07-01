{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nix-tree # Visualize Nix store dependencies
    nixfmt-rfc-style # Formatter for Nix expressions
  ];
}

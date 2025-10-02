# shell.nix - Development shell for nix-dots
{ pkgs ? import <nixpkgs> { }, }:

pkgs.mkShell {
  name = "nix-dots-dev";

  buildInputs = with pkgs; [
    # Basic Nix tools
    nixfmt-rfc-style
    nix-prefetch-git

    # For secrets management
    sops
    gnupg

    # Helpful utilities
    git
    jq
    gum # Modern shell prompts and UI

    # Add more tools as needed
  ];

  shellHook = ''
    echo "Welcome to nix-dots development environment!"
    echo "Available commands:"
    echo "  nixfmt      - Format Nix files"
    echo "  gum         - Modern shell prompts and UI"
    echo "  smart-switch - Intelligent NixOS workflow (./scripts/smart-switch.sh)"
  '';
}

# shell.nix - Development shell for nix-dots
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  name = "nix-dots-dev";
  
  buildInputs = with pkgs; [
    # Basic Nix tools
    nixfmt
    nix-prefetch-git
    
    # For secrets management
    sops
    gnupg
    
    # Helpful utilities
    git
    jq
    
    # Add more tools as needed
  ];

  shellHook = ''
    echo "Welcome to nix-dots development environment!"
    echo "Available commands:"
    echo "  nixfmt    - Format Nix files"
  '';
}

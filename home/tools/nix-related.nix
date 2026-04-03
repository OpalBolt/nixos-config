{ pkgs, ... }:
{ home.packages = with pkgs; [ nix-tree nixfmt-rfc-style ]; }

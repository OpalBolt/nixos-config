{ pkgs, lib, ... }:

{
  imports = [
    ./neovim
  ];

  neovim.enable = true;
}

{ pkgs, lib, vars, ... }:

{
  imports = [
    ./zellij
    ./starship
  ];
  zellij.enable = true;

  # Define what status line to use
  starship.enable = true;
}

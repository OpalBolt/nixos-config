{ pkgs, lib, ... }:

{
 imports = [
    ./zsh
    ./starship
  ];

  # Define what shell is to be used
  zsh.enable = true;

  # Define what status line to use
  starship.enable = true;
}

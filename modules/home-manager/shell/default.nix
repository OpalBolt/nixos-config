{ pkgs, lib, ... }:

{
 imports = [
    ./zsh
  ];

  # Define what shell is to be used
  zsh.enable = true;

}

{ pkgs, lib, ... }:

{
 imports = [
    ./zsh
  ];

  zsh.enable = true;
}

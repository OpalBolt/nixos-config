{ pkgs, lib, vars, ... }:

{
  imports = [
    ./zellij
  ];
  zellij.enable = true;
}

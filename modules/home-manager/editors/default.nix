{ pkgs, lib, ... }:

{
  imports = [
    ./nixvim
  ];

  nixvim.enable = true;
}

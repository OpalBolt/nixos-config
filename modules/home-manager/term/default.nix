{ pkgs, lib, ... }:

{
 imports = [
    ./kitty
  ];

  kitty.enable = true;
}

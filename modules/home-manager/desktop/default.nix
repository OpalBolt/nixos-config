{ pkgs, lib, ... }:

{
 imports = [
    ./rofi
  ];

  rofi.enable = true;

}

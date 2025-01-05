{ pkgs, lib, ... }:

{
 imports = [
    ./rofi
    ./dunst
  ];

  rofi.enable = true;
  dunst.enable = true;
}

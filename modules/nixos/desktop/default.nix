{ pkgs, lib, ... }:

{
 imports = [
    ./gnome
  ];

  gnome.enable = true;
}

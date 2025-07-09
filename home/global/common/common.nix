{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    make
    kdePackages.okular
  ];
}

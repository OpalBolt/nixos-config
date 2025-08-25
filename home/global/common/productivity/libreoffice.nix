{ pkgs, ... }:

{
  home.packages = with pkgs; [
    libreoffice # Document management
  ];
}

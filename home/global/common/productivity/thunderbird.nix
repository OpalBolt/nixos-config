{ pkgs, ... }:

{
  home.packages = with pkgs; [
    thunderbird # Email client
  ];
}

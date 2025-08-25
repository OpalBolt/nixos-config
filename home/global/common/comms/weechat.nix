{ pkgs, ... }:
{
  home.packages = with pkgs; [
    weechat
  ];
}

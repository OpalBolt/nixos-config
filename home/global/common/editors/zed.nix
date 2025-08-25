{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
  };
  home.packages = with pkgs; [
    nixd
  ];
}

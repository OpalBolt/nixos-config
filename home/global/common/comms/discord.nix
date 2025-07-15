{ pkgs, ... }:
{
  home.packages = with pkgs; [
    discord
    gurk-rs
  ];
}

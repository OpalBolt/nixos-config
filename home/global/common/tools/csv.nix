{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qsv
    csvlens
  ];
}

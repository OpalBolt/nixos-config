{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qsv
    csvlense
  ];
}

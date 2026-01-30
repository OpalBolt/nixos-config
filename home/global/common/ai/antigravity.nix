{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ antigravity-fhs ];
}

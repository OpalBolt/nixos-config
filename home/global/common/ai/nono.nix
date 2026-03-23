{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ nono ];
}

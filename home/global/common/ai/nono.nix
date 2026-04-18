{ pkgs, ... }:

{
  home.packages = with pkgs.unstable-small; [ nono ];
}

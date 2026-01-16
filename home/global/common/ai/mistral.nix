{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ mistral-vibe ];
}

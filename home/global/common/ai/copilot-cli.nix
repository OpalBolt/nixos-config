{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [ copilot-cli ];
}

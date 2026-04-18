{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    github-copilot-cli
  ];
}

{ pkgs, ... }:

{
  programs.gemini-cli = {
    enable = true;
    package = pkgs.unstable.gemini-cli;
  };
}

{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:
let
  username = hostSpec.username;
  homeDir = hostSpec.home;
  shell = hostSpec.shell or pkgs.zsh;
in
{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
    (lib.custom.relativeToRoot "home/global/core")
  ];
  services.ssh-agent.enable = true;
  home = {
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault homeDir;
    stateVersion = lib.mkDefault "24.05";
    sessionVariables = {
      CUSTOMERS_PATH = "/home/mads/git/work/customers/";
      EDITOR = lib.mkDefault "nvim";
      VISUAL = lib.mkDefault "nvim";
      FLAKE = lib.mkDefault "${homeDir}/nix-dots";
      SHELL = "zsh";
      TERM = "kitty";
      TERMINAL = "kitty";
    };
    file = {
      "scripts" = {
        source = lib.custom.relativeToRoot "dotfiles/scripts";
        recursive = true;
      };
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported
  };
}

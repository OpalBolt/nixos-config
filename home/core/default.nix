{
  config,
  lib,
  pkgs,
  userVars,
  systemVars,
  ...
}:
let
  username = userVars.username;
  homeDir = userVars.home;
  shell = userVars.shell or pkgs.zsh;
in
{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
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
      FLAKE = lib.mkDefault "${homeDir}/git/Nix/dot.nix";
      SHELL = lib.getExe shell;
    };
    preferXdgDirectories = true; # whether to make programs use XDG directories whenever supported

  };

  # Install core packages
  home.packages = builtins.attrValues {
    inherit (pkgs)
      coreutils # basic gnu utils
      direnv # environment per directory
      dust # disk usage
      eza # ls replacement
      nmap # network scanner
      trashy # trash cli
      unrar # rar extraction
      unzip # zip extraction
      zip # zip compression
      fastfetch # fast fetching system information
      ;
  };

  # Disable local manual pages
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  # Configure Nix package manager for this user's home environment
  nix = {
    # Specify which Nix package to use (defaults to the one from pkgs)
    package = lib.mkDefault pkgs.nix;
    settings = {
      # Enable experimental features for Nix
      experimental-features = [
        "nix-command" # Enables the new nix command-line interface
        "flakes" # Enables the flakes feature for reproducible builds
      ];
      # Disable warnings about uncommitted changes in flake repositories
      warn-dirty = false;
    };
  };

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

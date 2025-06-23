{
  config,
  lib,
  pkgs,
  hostSpec,
  ...
}:

{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
  ];

  services.ssh-agent.enable = true;

  # Install core packages
  home.packages = builtins.attrValues {
    inherit (pkgs)
      bottom # preformance top monitor
      coreutils # basic gnu utils
      curl # data transfer
      direnv # environment per directory
      dust # disk usage
      eza # ls replacement
      fastfetch # fast fetching system information
      fd # fast file search
      findutils # find files
      fzf # fuzzy file finder
      git # version control
      jq # json processor
      ncdu # network disk usage
      nmap # network scanner
      trashy # trash cli
      unrar # rar extraction
      unzip # zip extraction
      usbutils # usb device management
      wev # Show wayaland events
      wget # download files from the web
      xdg-user-dirs # manage user directories
      xdg-utils # XDG compliant utilities
      yq-go # yaml processor
      zip # zip compression
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

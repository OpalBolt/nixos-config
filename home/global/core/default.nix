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
      # Core System Utilities
      coreutils # basic gnu utils
      findutils # find files
      util-linux # Essential Linux system utilities (mount, fdisk, etc.)

      # File Management & Search
      dust # disk usage
      eza # ls replacement
      fd # fast file search
      fzf # fuzzy file finder
      ncdu # network disk usage
      trashy # trash cli

      # Archive & Compression
      unrar # rar extraction
      unzip # zip extraction
      zip # zip compression

      # Network Tools
      curl # data transfer
      nmap # network scanner
      wget # download files from the web

      # Development & Version Control
      direnv # environment per directory
      git # version control

      # Data Processing
      jq # json processor
      yq-go # yaml processor

      # System Monitoring & Performance
      bottom # preformance top monitor
      fastfetch # fast fetching system information

      # System Information & Hardware
      pciutils # Tools for inspecting PCI devices
      usbutils # Tools for inspecting USB devices

      # Desktop Environment
      wev # Show wayaland events
      xdg-user-dirs # manage user directories
      xdg-utils # XDG compliant utilities
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

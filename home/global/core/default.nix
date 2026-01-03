{
  lib,
  pkgs,
  ...
}:

{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
  ];

  # Install core packages
  home.packages = builtins.attrValues {
    inherit (pkgs)
      # Core System Utilities
      coreutils # basic gnu utils
      findutils # find files
      util-linux # Essential Linux system utilities (mount, fdisk, etc.)
      cowsay # Essential CLI tool to provide formated echos

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
      #bottom # preformance top monitor
      ttop # preformance top monitor
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

  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

}

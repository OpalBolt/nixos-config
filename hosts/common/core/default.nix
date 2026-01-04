{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = lib.flatten [
    inputs.sops-nix.nixosModules.sops
    (lib.custom.scanPaths ./.)
    (map lib.custom.relativeToRoot [ "new-modules/common" ])
  ];

  # Pass networking and email from nix-secrets to hostSpec
  hostSpec = {
    inherit (inputs.nix-secrets) networking email;
  };

  # Essential system packages required for all hosts
  environment = {
    systemPackages = with pkgs; [
      # Core utilities
      curl
      git
      nano
      openssh
      wget

      # Security and secrets management
      sops
      openssl

      # System utilities
      perl
      python3

      # File management and viewing
      bat
      yazi
    ];
    enableAllTerminfo = true;
    defaultPackages = lib.mkForce [ ];
  };

  # Nix helper for system management
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 20d --keep 20";
    };
    flake = "${config.hostSpec.home}/git/Nix/dot.nix/";
  };

  # Hardware and firmware
  hardware.enableRedistributableFirmware = true;

  # Nix daemon configuration
  documentation.nixos.enable = lib.mkForce false;
  nix.settings = {
    # Build settings
    cores = 2;
    max-jobs = 1;

    # Connection and logging - https://jackson.dev/post/nix-reasonable-defaults/
    connect-timeout = 5;
    log-lines = 25;

    # Disk space management
    min-free = 128000000; # 128MB
    max-free = 1000000000; # 1GB

    # Security and optimization
    trusted-users = [ "@wheel" ];
    auto-optimise-store = true;
    warn-dirty = false;
    allow-import-from-derivation = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}

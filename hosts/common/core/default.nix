{
  inputs,
  outputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = lib.flatten [
    inputs.home-manager.nixosModules.home-manager # Home Manager module
    inputs.sops-nix.nixosModules.sops
    (lib.custom.scanPaths ./.) # Scan for all modules in the current directory

    (map lib.custom.relativeToRoot [
      "new-modules/common"
      # "modules/hosts/common"
      # "modules/hosts/${platform}"
      # "hosts/common/core/${platform}.nix"
      # "hosts/common/core/sops.nix" # Core because it's used for backups, mail
      # "hosts/common/core/ssh.nix"
      # #"hosts/common/core/services" #not used yet
      # "hosts/common/users/primary"
      # "hosts/common/users/primary/${platform}.nix"
    ])
  ];

  hostSpec = {
    inherit (inputs.nix-secrets)
      networking
      email
      ;
  };

  ## Install critical packages ##
  environment.systemPackages = with pkgs; [
    curl
    git
    sops
    nano
    openssh
    sshfs
    wget
    yazi
    perl
    bat
    openssl
    openvpn
  ];

  # Enables simple printing support
  services.printing.enable = true;

  # Force Home Manager to use global packages
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";

  ## Localization and Timezone ##
  i18n.defaultLocale = config.hostSpec.locale;
  time.timeZone = config.hostSpec.timezone;
  networking.timeServers = [ "dk.pool.ntp.org" ];

  ## Nix Helper ##
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 20d --keep 20";
    flake = "${config.hostSpec.home}/git/Nix/dot.nix/";
  };

  ## SUDO and Terminal ##
  environment.enableAllTerminfo = true;
  #hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true; # Enable redistributable firmware, alternative to enableAllFirmware

  security.sudo = {
    extraConfig = ''
      Defaults lecture = never # rollback results in sudo lectures after each reboot, it's somewhat useless anyway
      Defaults pwfeedback # password input feedback - makes typed password visible as asterisks
      Defaults timestamp_timeout=120 # only ask for password every 2h1
    '';
  };

  environment.shells = with pkgs; [
    bash
    zsh
  ];

  ## NIX related ##
  documentation.nixos.enable = lib.mkForce false;
  nix = {
    settings = {

      cores = 2;
      max-jobs = 4;
      # See https://jackson.dev/post/nix-reasonable-defaults/
      connect-timeout = 5;
      log-lines = 25;
      min-free = 128000000; # 128MB
      max-free = 1000000000; # 1GB

      trusted-users = [ "@wheel" ];
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      warn-dirty = false;

      allow-import-from-derivation = true;

      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  # Disable default packages
  environment.defaultPackages = lib.mkForce [ ];

}

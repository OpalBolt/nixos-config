{ ... }:
{
  den.aspects.nix-settings = {
    includes = [
      ({ host, ... }: {
        nixos.programs.nh.flake = host.flakePath;
      })
    ];
    nixos = { lib, pkgs, ... }: {
      environment = {
        enableAllTerminfo = true;
        defaultPackages = lib.mkForce [ ];
        systemPackages = with pkgs; [
          curl
          git
          nano
          openssh
          wget
          sops
          openssl
          perl
          python3
          bat
          yazi
          tree
        ];
      };
      hardware.enableRedistributableFirmware = true;
      documentation.nixos.enable = lib.mkForce false;
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 20d --keep 20";
      };
      programs.git.enable = true;
      programs.zsh.enable = true;
      nix.settings = {
        cores = 2;
        max-jobs = 1;
        connect-timeout = 5;
        log-lines = 25;
        min-free = 128000000;
        max-free = 1000000000;
        trusted-users = [ "@wheel" ];
        auto-optimise-store = true;
        warn-dirty = false;
        allow-import-from-derivation = true;
        experimental-features = [ "nix-command" "flakes" ];
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [ nix-tree nixfmt-rfc-style ];
    };
  };
}

{ pkgs, config, ... }:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  # VPN secrets configuration
  sops.secrets = {
    resticKey = {
      key = "user/resticPassword";
      sopsFile = "${secretspath}/secrets/ceris.yaml";
    };
  };

  environment.systemPackages = with pkgs; [
    restic
    rclone
  ];
  services.restic.backups = {
    gdrive = {
      user = "backups";
      repository = "rclone:gdrive:/backups";
      initialize = true; # initializes the repo, don't set if you want manual control
      passwordFile = config.sops.secrets.resticKey.path;
      paths = [
        "/home/${config.users.users.mads.name}/git/work"
      ]
      user = "backups";
    };
  };
}

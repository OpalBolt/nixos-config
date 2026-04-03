{ inputs, config, osConfig, ... }:
let
  customersPath =
    config.home.sessionVariables.CUSTOMERS_PATH or "${config.home.homeDirectory}/git/work/customers";
  secretspath = toString inputs.nix-secrets.outPath;
  hostname = osConfig.networking.hostName;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.secrets = {
    client_id.sopsFile = "${secretspath}/secrets/${hostname}-rclone.yaml";
    client_secret.sopsFile = "${secretspath}/secrets/${hostname}-rclone.yaml";
    token.sopsFile = "${secretspath}/secrets/${hostname}-rclone.yaml";
    team_drive.sopsFile = "${secretspath}/secrets/${hostname}-rclone.yaml";
  };

  programs.rclone = {
    enable = true;
    requiresUnit = "sops-nix.service";
    remotes.gdrive = {
      config = {
        type = "drive";
        scope = "drive";
      };
      secrets = {
        client_id = config.sops.secrets.client_id.path;
        client_secret = config.sops.secrets.client_secret.path;
        token = config.sops.secrets.token.path;
        team_drive = config.sops.secrets.team_drive.path;
      };
      mounts.Customers = {
        enable = true;
        mountPoint = "${config.home.homeDirectory}/git/work/customers";
      };
    };
  };
}

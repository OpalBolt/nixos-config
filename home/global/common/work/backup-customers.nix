{
  inputs,
  config,
  hostSpec,
  ...
}:
let
  customersPath =
    config.home.sessionVariables.CUSTOMERS_PATH or "${config.home.homeDirectory}/git/work/customers";
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  # Configure Secrets
  sops.secrets = {
    client_id = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}-rclone.yaml";
    };

    client_secret = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}-rclone.yaml";
    };

    token = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}-rclone.yaml";
    };

    team_drive = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}-rclone.yaml";
    };
  };

  programs.rclone = {
    enable = true;
    # Ensure sops secrets are ready before rclone config is written
    requiresUnit = "sops-nix.service";

    remotes = {
      gdrive = {
        config = {
          type = "drive";
          scope = "drive";
          # Add client_id/client_secret here if you have custom ones
        };
        secrets = {
          client_id = config.sops.secrets.client_id.path;
          client_secret = config.sops.secrets.client_secret.path;
          token = config.sops.secrets.token.path;
          team_drive = config.sops.secrets.team_drive.path;
        };

        mounts = {
          Customers = {
            enable = true;
            mountPoint = "${config.home.homeDirectory}/git/work/customers";
          };
        };
      };
    };
  };
}

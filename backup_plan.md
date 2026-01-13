# Customer Backup & Mount Implementation Plan

This plan sets up a robust Google Drive integration using the `home-manager` `programs.rclone` module. It provides:
1.  **Secure Secrets**: Storing the Google Drive token in `sops`.
2.  **Managed Mount**: Using `programs.rclone` to handle the configuration and systemd mount service.
3.  **Backup Service**: A dedicated background service to sync your `customers` folder to the drive.

## Prerequisites

Ensure you have your Google Drive `rclone` config ready. If not, run `rclone config` on a machine with a browser to generate it. You specifically need the `token` JSON blob.

## Step 1: Add Secrets to Sops

We will store just the sensitive token in sops.

1.  Edit your shared secrets file:
    ```bash
    sops secrets/shared.yaml
    ```
2.  Add the `rclone_token` key. Paste **only the JSON content** of the token (the part inside `{...}`).
    ```yaml
    rclone_token: '{"access_token":"...","expiry":"..."}'
    ```
    *Note: Ensure the JSON string is properly quoted or formatted so YAML parses it as a string.*

## Step 2: System Configuration (Fuse)

To allow `rclone mount` to work for a non-root user, we need to enable `fuse` in your NixOS configuration.

**File:** `hosts/common/core/default.nix`
**Action:** Add the following configuration:

```nix
  environment.systemPackages = [ pkgs.fuse ];
  programs.fuse.userAllowOther = true;
```

## Step 3: Create the Rclone Module

We will create a home-manager module that utilizes `programs.rclone`.

**File:** `home/global/common/services/rclone.nix` (Create this file)

```nix
{ pkgs, config, lib, ... }:
let
  customersPath = config.home.sessionVariables.CUSTOMERS_PATH or "${config.home.homeDirectory}/git/work/customers";
in
{
  # Configure Secret
  sops.secrets.rclone_token = {
    sopsFile = lib.custom.relativeToRoot "secrets/shared.yaml";
    # This secret will be used by the rclone module
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
          token = config.sops.secrets.rclone_token.path;
        };
        
        mounts = {
          google-drive = {
            enable = true;
            mountPoint = "${config.home.homeDirectory}/GoogleDrive";
            options = [
              "--vfs-cache-mode writes"
              "--dir-cache-time 5s"
            ];
          };
        };
      };
    };
  };

  # 2. Backup Service (Sync Customers)
  # Automatically syncs the local customers folder to 'gdrive:Customers'
  # We manually define this as programs.rclone doesn't provide periodic sync services yet.
  systemd.user.services.backup-customers = {
    Unit = {
      Description = "Backup Customers to Google Drive";
      After = [ "network-online.target" ];
    };
    Service = {
      Type = "oneshot";
      # programs.rclone manages the config at default location: ~/.config/rclone/rclone.conf
      ExecStart = "${pkgs.rclone}/bin/rclone sync ${customersPath} gdrive:Customers --verbose";
    };
  };

  # Timer for Backup (Run every hour)
  systemd.user.timers.backup-customers = {
    Unit = {
      Description = "Schedule Customer Backup";
    };
    Timer = {
      OnCalendar = "hourly";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
```

## Step 4: Enable the Module

Import the new module into your user configuration.

**File:** `home/users/mads/core/default.nix`

```nix
{ ... }:
{
  imports = [
    # ... existing imports
    (lib.custom.relativeToRoot "home/global/common/services/rclone.nix")
  ];
}
```

## Step 5: Update Scripts (Optional)

Update `@dotfiles/scripts/customers.sh` or create a manual backup alias:

```bash
# Trigger manual backup
systemctl --user start backup-customers.service
```

## Summary of Changes to Apply
1.  **Edit `secrets/shared.yaml`**: Add `rclone_token`.
2.  **Edit `hosts/common/core/default.nix`**: Enable `programs.fuse.userAllowOther = true`.
3.  **Create `home/global/common/services/rclone.nix`**: Paste the module code above.
4.  **Edit `home/users/mads/core/default.nix`**: Import the new module.
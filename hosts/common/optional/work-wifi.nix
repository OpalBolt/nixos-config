{
  config,
  inputs,
  pkgs,
  vars,
  hostSpec,
  ...
}:

# Network manager configuration nix:
# https://search.nixos.org/options?channel=25.05&show=networking.networkmanager.ensureProfiles.profiles&from=0&size=50&sort=relevance&type=packages&query=networking.networkmanager.ensureProfiles
#
# Network manager configuration man
# https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html
#
# Network manager file explanation
# https://linux.die.net/man/5/wpa_supplicant.conf
#
# Sops values are set in security.nix

{
  networking.networkmanager.ensureProfiles = {
    secrets = {
      entries = [
        {
          file = config.sops.secrets.key_password.path;
          key = "private-key-password";
          matchId = "Eficode Group"; # Must match connection.id exactly
          matchSetting = "802-1x";
          matchType = "wifi";
        }
      ];
    };
    profiles = {
      Eficode_wifi = {
        connection = {
          id = "Eficode Group";
          #permissions = "mads:mads";
          type = "wifi";
          interface-name = "wlp9s0";
          autoconnect = true;
          autoconnect-priority = 0; # ← sets priority
        };
        wifi = {
          mode = "infrastructure";
          ssid = "Eficode Group";
          security = "802-11-wireless-security";
        };
        wifi-security = {
          key-mgmt = "wpa-eap";
        };
        "802-1x" = {
          eap = "tls";
          identity = "anonymous";
          ca-cert = config.sops.secrets.ca_cert.path;
          client-cert = config.sops.secrets.user_cert.path;
          private-key = config.sops.secrets.user_key.path;
          private-key-password-flags = 1;

          # The nm-file-secret-agent will automatically provide the password
          # from the sops secret file when NetworkManager requests it
          private-key-password = inputs.nix-secrets.work.wifi;

        };
        ipv4 = {
          method = "auto";
        };
        ipv6 = {
          method = "auto";
        };
      };
    };
  };

}

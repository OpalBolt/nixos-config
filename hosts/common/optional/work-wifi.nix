{
  config,
  pkgs,
  vars,
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
          matchId = "Eficode_wifi";
          matchSetting = "802-1x";
          matchType = "wifi";
        }
      ];
    };
    environmentFiles = [
      config.sops.secrets.key_password.path
    ];
    profiles = {
      Eficode_wifi = {
        connection = {
          id = "Eficode_wifi";
          #permissions = "mads:mads";
          type = "wifi";
          interface-name = "wlp9s0";
          autoconnect = true;
          autoconnect-priority = 10; # ← sets priority
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
          ca-cert = "/run/secrets/wifi/ca_cert";
          client-cert = "/run/secrets/wifi/user_cert";
          private-key = "/run/secrets/wifi/user_key";
          #private-key-password-flags = 1;

          # $FILE is used in order for network managed to know to read from file
          # This is not a NIX thing, this is related to NM
          #private-key-password = builtins.readFile config.sops.secrets.key_password.path;
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

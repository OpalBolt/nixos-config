{ inputs, ... }:
{
  # Parametric: uses host.name to build the per-host wifi secret file path.
  # Secret ownership is hardcoded to "mads" since this aspect is only used on mads' work machines.
  den.aspects.work-wifi.includes = [
    ({ host, ... }: {
      nixos = { config, ... }: {
        sops.secrets = {
          ca_cert = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-wifi.yaml";
            owner = "mads";
            path = "/run/wifi/ca_cert.cer";
          };
          user_cert = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-wifi.yaml";
            owner = "mads";
            path = "/run/wifi/user_cert.pem";
          };
          user_key = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-wifi.yaml";
            owner = "mads";
            path = "/run/wifi/user_key.key";
          };
          key_password = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-wifi.yaml";
            owner = "mads";
            path = "/run/wifi/key_password";
          };
        };
        networking.networkmanager.ensureProfiles = {
          secrets.entries = [
            {
              file = config.sops.secrets.key_password.path;
              key = "private-key-password";
              matchId = "Eficode Group";
              matchSetting = "802-1x";
              matchType = "wifi";
            }
          ];
          profiles.Eficode_wifi = {
            connection = {
              id = "Eficode Group";
              type = "wifi";
              interface-name = "wlp192s0";
              autoconnect = true;
              autoconnect-priority = 0;
            };
            wifi = {
              mode = "infrastructure";
              ssid = "Eficode Group OLD";
              security = "802-11-wireless-security";
            };
            wifi-security.key-mgmt = "wpa-eap";
            "802-1x" = {
              eap = "tls";
              identity = "anonymous";
              ca-cert = config.sops.secrets.ca_cert.path;
              client-cert = config.sops.secrets.user_cert.path;
              private-key = config.sops.secrets.user_key.path;
              private-key-password-flags = 1;
              private-key-password = "$FILE:${config.sops.secrets.key_password.path}";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
          };
        };
      };
    })
  ];
}

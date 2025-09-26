{
  inputs,
  config,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  # VPN secrets configuration
  sops.secrets = {
    home-vpn-private-key = {
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
      key = "home-vpn/PrivateKey";
    };
    home-vpn-preshared-key = {
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
      key = "home-vpn/PresharedKey";
    };
  };

  # WireGuard VPN configuration
  networking.wg-quick.interfaces = {
    wg0 = {
      autostart = true;
      address = [
        "10.10.12.3/32"
      ];
      dns = [
        "192.168.4.1"
      ];
      privateKeyFile = config.sops.secrets.home-vpn-private-key.path;

      peers = [
        {
          publicKey = inputs.nix-secrets.Wireguard.server-public-key;
          presharedKeyFile = config.sops.secrets.home-vpn-preshared-key.path;
          allowedIPs = [
            "192.168.60.0/24"
            "192.168.4.1/32"
          ];
          endpoint = inputs.nix-secrets.Wireguard.endpoint;
        }
      ];
    };
  };
}

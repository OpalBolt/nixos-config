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
      key = "home-vpn/PrivateKey";
      sopsFile = "${secretspath}/secrets/shared.yaml";
    };
    home-vpn-preshared-key = {
      key = "home-vpn/PresharedKey";
      sopsFile = "${secretspath}/secrets/shared.yaml";
    };
  };

  # WireGuard VPN configuration
  networking.wg-quick.interfaces = {
    wg0 = {
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
            "0.0.0.0/0"
            "::/0"
          ];
          endpoint = inputs.nix-secrets.Wireguard.endpoint;
          persistentKeepalive = 25;
        }
      ];
    };
  };
}

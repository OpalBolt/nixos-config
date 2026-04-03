{ inputs, ... }:
{
  den.aspects.vpn.nixos = { config, ... }: {
    sops.secrets = {
      home-vpn-private-key = {
        sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/per-mads.yaml";
        key = "home-vpn/PrivateKey";
      };
      home-vpn-preshared-key = {
        sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/per-mads.yaml";
        key = "home-vpn/PresharedKey";
      };
    };
    networking.wg-quick.interfaces.wg0 = {
      autostart = false;
      address = [ "10.10.12.3/32" ];
      dns = [ "192.168.4.1" ];
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

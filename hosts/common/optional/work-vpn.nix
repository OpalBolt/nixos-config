{
  inputs,
  config,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];
  sops.secrets.openvpn-efi = {
    # VPN configuration
    sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}-vpn.yaml";
    key = "openvpn";
  };
  sops.secrets = {
    wireguard-privatekey = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}-vpn.yaml";
      key = "wireguard/PrivateKey";
    };
  };
  networking.wg-quick.interfaces = {
    wireguard-work = {
      autostart = true;
      address = [
        "192.168.8.8/32"
      ];
      dns = [
        "192.168.8.1"
      ];
      privateKeyFile = config.sops.secrets.wireguard-privatekey.path;

      peers = [
        {
          publicKey = inputs.nix-secrets.Wireguard-work.server-public-key;
          allowedIPs = inputs.nix-secrets.Wireguard-work.allowedips;

          #allowedIPs = [ "0.0.0.0/0" ];
          endpoint = inputs.nix-secrets.Wireguard-work.endpoint;
        }
      ];
    };
  };
}

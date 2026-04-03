{ inputs, ... }:
{
  # Parametric: uses host.name to build the per-host sops secret file path.
  den.aspects.work-vpn.includes = [
    ({ host, ... }: {
      nixos = { config, ... }: {
        sops.secrets = {
          openvpn-efi = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-vpn.yaml";
            key = "openvpn";
          };
          wireguard-privatekey = {
            sopsFile = "${toString inputs.nix-secrets.outPath}/secrets/${host.name}-vpn.yaml";
            key = "wireguard/PrivateKey";
          };
        };
        networking.wg-quick.interfaces.wireguard-work = {
          autostart = false;
          address = [ "192.168.8.8/32" ];
          dns = [ "192.168.8.1" ];
          privateKeyFile = config.sops.secrets.wireguard-privatekey.path;
          peers = [
            {
              publicKey = inputs.nix-secrets.Wireguard-work.server-public-key;
              allowedIPs = inputs.nix-secrets.Wireguard-work.allowedips;
              endpoint = inputs.nix-secrets.Wireguard-work.endpoint;
            }
          ];
        };
      };
    })
  ];
}

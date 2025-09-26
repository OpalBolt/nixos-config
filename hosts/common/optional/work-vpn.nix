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
}

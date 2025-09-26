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

  # Base SOPS configuration
  sops = {
    defaultSopsFile = "${secretspath}/secrets/shared.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  # All secrets organized by type
  sops.secrets = {

    # VPN configuration
    openvpn-efi = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}-vpn.yaml";
      key = "openvpn";
    };
  };
}

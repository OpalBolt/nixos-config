{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.nix-secrets;
in

{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets/shared.yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };

  sops.secrets.openvpn-work = {
    sopsFile = "${secretspath}/secrets/ceris.yaml";
    key = "openvpn/work";
  };
}

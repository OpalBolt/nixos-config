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

  sops.secrets."mads/ssh-key-pub" = {
    owner = config.users.users.mads.name;
    path = "/home/mads/.ssh/id_ed25519.pub";
  };
  sops.secrets."mads/ssh-key-priv" = {
    owner = config.users.users.mads.name;
    path = "/home/mads/.ssh/id_ed25519";
  };

  sops.secrets.ca_cert = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/workwifi.yaml";
  };

  sops.secrets.user_cert = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/workwifi.yaml";
  };

  sops.secrets.user_key = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/workwifi.yaml";
  };

  sops.secrets.key_password = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/workwifi.yaml";
  };

}

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
    age.keyFile = "${config.hostSpec.home}/.config/sops/age/keys.txt";
    #age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}

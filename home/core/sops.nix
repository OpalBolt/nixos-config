{ inputs, config, ... }:
let
  secretspath = toString inputs.nix-secrets.outPath;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];
  sops = {
    defaultSopsFile = "${secretspath}/secrets/shared.yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519" ];
  };
}

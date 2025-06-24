{
  inputs,
  config,
  hostSpec,
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
    # SSH keys
    "ssh/privateKey" = {
      owner = config.users.users.${config.hostSpec.username}.name;
      path = "/home/${config.hostSpec.username}/.ssh/id_ed25519"; # Private key
      key = "opalbolt/ssh-key-priv";
    };
    "ssh/publicKey" = {
      owner = config.users.users.${config.hostSpec.username}.name;
      path = "/home/${config.hostSpec.username}/.ssh/id_ed25519.pub"; # Public key
      key = "opalbolt/ssh-key-pub";
    };

    hashedPassword = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}.yaml";
      key = "user/password";
    };
    rootHashedPassword = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}.yaml";
      key = "user/rootPassword";
    };
  };
}

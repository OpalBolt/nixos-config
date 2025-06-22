{ inputs, config, ... }:
let
  secretspath = builtins.toString inputs.nix-secrets;

  # Common attributes for WiFi secrets
  wifi_secret = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/efi-wifi.yaml";
  };
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
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
      owner = config.users.users.mads.name;
      path = "/home/mads/.ssh/id_ed25519"; # Private key
    };
    "ssh/publicKey" = {
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
      owner = config.users.users.mads.name;
      path = "/home/mads/.ssh/id_ed25519.pub"; # Public key
    };

    # User-config
    personal-email = {
      sopsFile = "${secretspath}/secrets/per-mads.yaml";
      key = "email";
    };

    hashedPassword = {
      sopsFile = "${secretspath}/secrets/efi-mads.yaml";
      key = "user/password";
    };

    # VPN configuration
    openvpn-efi = {
      sopsFile = "${secretspath}/secrets/efi-vpn.yaml";
      key = "openvpn";
    };

    # WiFi certificates and keys - using shared attributes
    ca_cert = wifi_secret;
    user_cert = wifi_secret;
    user_key = wifi_secret;
    key_password = wifi_secret;
  };
}

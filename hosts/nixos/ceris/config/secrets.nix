{ inputs, config, hostSpec, ... }:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;

  # Common attributes for WiFi secrets
  wifi_secret = {
    owner = config.users.users.mads.name;
    sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}-wifi.yaml";
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
    
    # VPN configuration
    openvpn-efi = {
      sopsFile = "${secretspath}/secrets/${config.hostSpec.hostname}-vpn.yaml";
      key = "openvpn";
    };

    # WiFi certificates and keys - using shared attributes
    ca_cert = wifi_secret;
    user_cert = wifi_secret;
    user_key = wifi_secret;
    key_password = wifi_secret;
  };
}

{ inputs, ... }:
{
  den.aspects.sops-base = {
    # sops-nix nixos module added at flake-parts level (inputs available here)
    includes = [ { nixos = inputs.sops-nix.nixosModules.sops; } ];
    nixos = {
      sops = {
        defaultSopsFile = "${toString inputs.nix-secrets.outPath}/secrets/shared.yaml";
        age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519" ];
      };
    };
  };
}

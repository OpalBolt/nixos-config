{ ... }:
{
  den.aspects.containers.nixos = { pkgs, ... }: {
    virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = false;
        defaultNetwork.settings.dns_enabled = true;
      };
      docker.enable = true;
    };
    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      docker-compose
      podman-compose
    ];
  };
}

{ ... }:

{
  services.nextcloud-client.enable = true;
  systemd.user.services.nextcloud-client = {
    Unit = {
      After = pkgs.lib.mkForce "graphical-session.target";
    };
  };
}

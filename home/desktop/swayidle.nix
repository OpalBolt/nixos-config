{ pkgs, ... }:
{
  services.swayidle = {
    enable = true;
    extraArgs = [ "-w" ];
    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "loginctl lock-session";
      }
    ];
  };
}

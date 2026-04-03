{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    # -w makes swayidle wait for the lock command to finish before sleeping,
    # preventing a race where the screen suspends before swaylock is visible.
    extraArgs = [ "-w" ];
    events = [
      # Respond to `loginctl lock-session` and other logind lock signals.
      # This is the single handler that actually starts swaylock.
      { event = "lock"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      # Call swaylock directly before sleep to avoid a D-Bus round-trip race.
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
    timeouts = [
      # After 10 minutes of inactivity, send a lock-session signal so that
      # all lock handlers (swayidle lock event, other listeners) are notified.
      { timeout = 600; command = "loginctl lock-session"; }
    ];
  };
}

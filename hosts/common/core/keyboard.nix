{ pkgs, ... }:
{
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # use xkb options in tty
  console.useXkbConfig = true;

}

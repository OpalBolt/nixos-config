{
  pkgs,
  config,
  ...
}:
{
  # Configure keymap in X11
  services.xserver = {
    xkb.layout = config.hostSpec.kbdLayout;
    #variant = "";
  };

  # use xkb options in tty
  console.useXkbConfig = true;

}

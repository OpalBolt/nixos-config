{ pkgs, vars, ... }:

{
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.fullname;
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "audio"
      "video"
      "optical"
      "storage"
      "docker"
    ];
    # set default shell to bash, which launches fish
    # see: https://nixos.wiki/wiki/Fish
    shell = pkgs.zsh;
  };

  # Set your time zone.
  time.timeZone = vars.timezone;

  # Select internationalisation properties.
  i18n.defaultLocale = vars.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = vars.extraLocale;
    LC_IDENTIFICATION = vars.extraLocale;
    LC_MEASUREMENT = vars.extraLocale;
    LC_MONETARY = vars.extraLocale;
    LC_NAME = vars.extraLocale;
    LC_NUMERIC = vars.extraLocale;
    LC_PAPER = vars.extraLocale;
    LC_TELEPHONE = vars.extraLocale;
    LC_TIME = vars.extraLocale;
  };

  # Configure console keymap
  console.keyMap = vars.consoleKbdKeymap;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "dk";
    variant = "";
  };

}

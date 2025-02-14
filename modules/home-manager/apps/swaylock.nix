{
  config,
  lib,
  ...
}:

{
  options = {
    feature.apps.swaylock.enable = lib.mkEnableOption "Enables swaylock" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.apps.swaylock.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        show-failed-attemps = true;
        ignore-empty-password = true;
        font-size = 14;
        disable-caps-lock-text = true;
        indicator = true;
        indicator-caps-lock = true;
        indicator-radius = 50;
        indicator-thickness = 10;
        image = "/home/mads/nix-dots/dotfiles/bg.png";
        scaling = "fill";
      };
    };
  };
}

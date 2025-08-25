{
  config,
  lib,
  ...
}:

{
  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      ignore-empty-password = true;
      font-size = 14;
      disable-caps-lock-text = true;
      indicator-caps-lock = true;
      indicator-radius = 50;
      indicator-thickness = 10;
      image = "/home/mads/nix-dots/dotfiles/bg.png";
      scaling = "fill";
    };
  };
}

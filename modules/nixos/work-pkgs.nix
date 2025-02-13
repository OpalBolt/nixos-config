{
  lib,
  config,
  pkgs,
  ...
}:

{
  options.feature.work-pkgs.enable = lib.mkEnableOption "Work related packages";

  config = lib.mkIf config.feature.work-pkgs.enable {
    environment.systemPackages = with pkgs; [
      slack
      timewarrior
      devenv
      devbox
      awscli2
    ];
  };
}

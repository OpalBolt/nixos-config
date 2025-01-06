{lib, config, pkgs, ...}:

{
  options.nos.work-pkgs.enable = 
    lib.mkEnableOption "Work related packages";

  config = lib.mkIf config.nos.work-pkgs.enable {
    environment.systemPackages = with pkgs; [
      slack
    ];
  };
}

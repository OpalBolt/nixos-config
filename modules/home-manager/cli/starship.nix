{pkgs, config, lib, ... }:

{
  options = {
    starship.enable = 
      lib.mkEnableOption "Enables starship";
  };

  config = lib.mkIf config.zsh.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./configfiles/starship-config.toml;
    };
  };
}

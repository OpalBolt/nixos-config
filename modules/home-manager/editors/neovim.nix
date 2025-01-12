{
  config,
  lib,
  ...
}:

{
  options = {
    feature.cli.neovim.enable = lib.mkEnableOption "Enables neovim" // {
      default = true;
    };
  };
  config = lib.mkIf config.feature.cli.neovim.enable {
    home.file."config/nvim".source = 
    	lib.file.mkOutOfStireSymlink ./configfiles/neovim-config;
    #xdg.configFile.".config/nvim".source = ./configfiles/neovim-config;
    programs.neovim = {
      enable = true;
    };
  };
}

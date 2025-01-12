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
    programs.neovim = {
      enable = true;
    };
  };
}

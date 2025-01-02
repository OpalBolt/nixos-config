{ config, lib, vars, ...}:{

  options = {
    neovim.enable = lib.mkEnableOption "Enables Neovim";
  };

  config = lib.mkIf config.neovim.enable {
    programs.neovim = {
      enable = true;
      #packages = pkgs.neovim
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
    };
  };
}

{ config, lib, vars, ...}:{

  options = {
    neovim.enable = lib.mkEnableOption "Enables Neovim";
  };

  config = lib.mkIf config.neovim.enable {
    home-manager.users.${vars.username} = {
      programs.neovim = {
        enable = true;
      };
    };
  };

}

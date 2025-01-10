{ config, lib, ... }:

{
  options = {
    module1.enable = lib.mkEnableOption "Enables module1";
  };

  config = lib.mkIf config.module1.enable {
    programs.app = {
      enable = true;
    };
  };
}

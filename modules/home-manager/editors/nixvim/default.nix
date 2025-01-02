{lib, config, inputs, pkgs, vars, ... }:

{
  options = {
    nixvim.enable = 
      lib.mkEnableOption "Enables nixvim";
  };

  config = lib.mkIf config.nixvim.enable {
    home.packages = [
      inputs.nixvim-config.packages.${vars.system}.default
    ];
  };
}

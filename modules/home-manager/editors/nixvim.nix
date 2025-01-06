{lib, config, inputs, pkgs, vars, ... }:

{
  options = {
    hm.editors.nixvim.enable = 
      lib.mkEnableOption "Enables nixvim"; // {default = true;};
  };

  config = lib.mkIf config.hm.editors.nixvim.enable {
    home.packages = [
      inputs.nixvim-config.packages.${vars.system}.default
    ];
  };
}

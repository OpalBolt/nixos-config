{lib, config, inputs, pkgs, vars, ... }:

{
  options = {
    nixvim.enable = 
      lib.mkEnableOption "Enables nixvim";
  };

  config = lib.mkIf config.nixvim.enable {
    home-manager.sharedModules = [
      (_: {
        home.packages = with pkgs; [
          inputs.nixvim.packages.${vars.system}.default
        ];
      })
    ];
  };
}

{
  lib,
  config,
  inputs,
  vars,
  ...
}:

{
  options = {
    feature.editor.nixvim.enable = lib.mkEnableOption "Enables nixvim" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.editor.nixvim.enable {
    home.packages = [
      inputs.nixvim-config.packages.${vars.system}.default
    ];
  };
}

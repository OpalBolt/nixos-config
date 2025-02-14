{ lib, config, ... }:
{
  options = {
    feature.apps.fuzzel.enable = lib.mkEnableOption "Enables fuzzel" // {
      default = true;
    };
  };

  config = lib.mkIf config.feature.apps.fuzzel.enable {
    programs.fuzzel = {
      enable = true;

      settings = {
        main = {
          font = "IosevkaTerm Nerd Font Mono:size=12";
          icons-enabled = false;
          icon-theme = "tela-circle-icon-theme";
          terminal = "kitty";
          width = 50;
          horizontal-pad = 48;
          vertical-pad = 28;
          line-height = 15;
        };

        colors = {
          background = "0c0c0980";
          #input = "abb2bfff";
          text = "eae5e1ff";
          match = "7E9CD8";
          #selection = "61afefff";
          #selection-text = "282c34ff";
          #selection-match = "282c34ff";
          border = "9e948966";
        };

        border = {
          width = 2;
          radius = 5;
        };
      };
    };
  };
}
